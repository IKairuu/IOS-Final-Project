//
//  MessageSocketController.swift
//  Project-Stella
//
//  Created by Mac-LAB on 10/14/26.
//

import SwiftUI

@MainActor
@Observable
final class MessageSocketController {
    var status: SocketStatus = .disconnected
    var lastError: String?
    
    // Set by the page: called for every Stella reply and generated task list
    var onMessage: ((MessageModel) -> Void)?
    var onTasks: (([TaskModel]) -> Void)?
    
    private let agent: StellaAgent
    private var socket: URLSessionWebSocketTask?
    private var token: String?
    private var reconnectAttempts = 0
    private var shouldStayConnected = false
    private let maxReconnectAttempts = 3
    
    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    init(agent: StellaAgent) {
        self.agent = agent
    }
    
    func connect(token: String?) {
        guard status == .disconnected else { return }
        self.token = token
        shouldStayConnected = true
        // Placeholder: the socket path and query params depend on the backend
        guard var components = URLComponents(string: Core().socketUrl) else {
            lastError = "Invalid socket URL"
            return
        }
        components.queryItems = [URLQueryItem(name: "agent", value: agent.rawValue)]
        guard let url = components.url else { return }
        
        var request = URLRequest(url: url)
        if let token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        status = .connecting
        let task = URLSession.shared.webSocketTask(with: request)
        socket = task
        task.resume()
        listen(on: task)
        // URLSessionWebSocketTask has no open callback, so a ping confirms the connection
        task.sendPing { [weak self] error in
            Task { @MainActor in
                // Ignore callbacks from a socket that was already replaced or closed
                guard let self, task === self.socket else { return }
                if let error {
                    self.handleFailure(error)
                } else {
                    self.status = .connected
                    self.reconnectAttempts = 0
                }
            }
        }
    }
    
    func disconnect() {
        shouldStayConnected = false
        reconnectAttempts = 0
        socket?.cancel(with: .normalClosure, reason: nil)
        socket = nil
        status = .disconnected
    }
    
    // Returns false when the socket is not connected so the page can fall back
    @discardableResult
    func send(_ message: MessageModel, userId: String?) -> Bool {
        guard status == .connected, let socket else { return false }
        let payload = OutgoingSocketMessage(agent: agent, userId: userId, messageId: message.id, content: message.content, sentAt: message.sentAt)
        guard let data = try? encoder.encode(payload), let text = String(data: data, encoding: .utf8) else { return false }
        socket.send(.string(text)) { [weak self] error in
            if let error {
                Task { @MainActor in self?.lastError = error.localizedDescription }
            }
        }
        return true
    }
    
    private func listen(on task: URLSessionWebSocketTask) {
        task.receive { [weak self] result in
            Task { @MainActor in
                guard let self, task === self.socket else { return }
                switch result {
                case .success(let message):
                    self.handle(message)
                    self.listen(on: task)
                case .failure(let error):
                    self.handleFailure(error)
                }
            }
        }
    }
    
    private func handle(_ message: URLSessionWebSocketTask.Message) {
        let data: Data?
        switch message {
        case .string(let text): data = text.data(using: .utf8)
        case .data(let raw): data = raw
        @unknown default: data = nil
        }
        guard let data, let payload = try? decoder.decode(IncomingSocketMessage.self, from: data) else { return }
        
        if let content = payload.content, !content.isEmpty {
            onMessage?(MessageModel(id: payload.messageId ?? UUID().uuidString, sender: .stella, content: content, sentAt: payload.sentAt ?? Date()))
        }
        if let tasks = payload.tasks, !tasks.isEmpty {
            onTasks?(tasks.map { $0.toTaskModel() })
        }
    }
    
    private func handleFailure(_ error: Error) {
        lastError = error.localizedDescription
        socket = nil
        status = .disconnected
        // Placeholder: simple retry, swap for backoff once the backend is live
        guard reconnectAttempts < maxReconnectAttempts else { return }
        reconnectAttempts += 1
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(2))
            // The page may have closed the socket while waiting
            guard self.shouldStayConnected else { return }
            self.connect(token: self.token)
        }
    }
}

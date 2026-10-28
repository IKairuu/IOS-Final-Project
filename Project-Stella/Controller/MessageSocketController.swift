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
    
    var onMessage: ((MessageModel) -> Void)?
    var onTasks: (([TaskModel]) -> Void)?
    
    private let agent: StellaAgent
    private var socket: URLSessionWebSocketTask?
    private var token: String?
    private var reconnectAttempts = 0
    private var shouldStayConnected = false
    private let maxReconnectAttempts = 3
    
    private let encoder = JSONEncoder()
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom(TaskDatasource.decodeDate)
        return decoder
    }()
    
    init(agent: StellaAgent) {
        self.agent = agent
    }
    
    func connect(token: String?) {
        guard status == .disconnected else { return }
        self.token = token
        shouldStayConnected = true
        guard let url = socketURL() else {
            lastError = "Invalid socket URL"
            return
        }
        
        var request = URLRequest(url: url)
        if let token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        status = .connecting
        let task = URLSession.shared.webSocketTask(with: request)
        socket = task
        task.resume()
        listen(on: task)
    }
    
    func disconnect() {
        shouldStayConnected = false
        reconnectAttempts = 0
        socket?.send(.string("41")) { _ in }
        socket?.cancel(with: .normalClosure, reason: nil)
        socket = nil
        status = .disconnected
    }
    
    @discardableResult
    func send(_ message: MessageModel, userId: String?) -> Bool {
        guard status == .connected else { return false }
        let payload = OutgoingSocketMessage(id: userId ?? "", agent: agent, message: message.content)
        return emit(payload)
    }
    
    @discardableResult
    func requestSummary(userId: String?) -> Bool {
        let message = MessageModel(sender: .user, content: "Give me a short summary of my tasks and events today, with one recommendation.")
        return send(message, userId: userId)
    }
    
    private func socketURL() -> URL? {
        guard var components = URLComponents(string: Core().socketUrl) else { return nil }
        switch components.scheme {
        case "https": components.scheme = "wss"
        case "http": components.scheme = "ws"
        default: break
        }
        components.path = "/socket.io/"
        components.queryItems = [URLQueryItem(name: "EIO", value: "4"),
                                 URLQueryItem(name: "transport", value: "websocket")]
        return components.url
    }
    
    private func emit(_ payload: OutgoingSocketMessage) -> Bool {
        guard let socket,
              let data = try? encoder.encode(payload),
              let body = String(data: data, encoding: .utf8) else { return false }
        socket.send(.string("42[\"\(agent.eventName)\",\(body)]")) { [weak self] error in
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
                    if case .string(let text) = message {
                        self.handle(text, on: task)
                    }
                    self.listen(on: task)
                case .failure(let error):
                    self.handleFailure(error)
                }
            }
        }
    }
    
    private func handle(_ packet: String, on task: URLSessionWebSocketTask) {
        if packet.hasPrefix("42") {
            handleEvent(String(packet.dropFirst(2)))
        } else if packet.hasPrefix("40") {
            status = .connected
            reconnectAttempts = 0
        } else if packet.hasPrefix("41") {
            handleFailure(nil)
        } else if packet.hasPrefix("0") {
            task.send(.string("40")) { _ in }
        } else if packet == "2" {
            task.send(.string("3")) { _ in }
        }
    }
    
    private func handleEvent(_ json: String) {
        guard let data = json.data(using: .utf8),
              let array = try? JSONSerialization.jsonObject(with: data) as? [Any],
              array.count > 1,
              array[0] as? String == agent.eventName else { return }
        
        var body = array[1]
        if let list = body as? [Any], let first = list.first {
            body = first
        }
        guard var object = body as? [String: Any] else { return }
        if let inner = object["message"] as? String,
           let innerData = inner.data(using: .utf8),
           let unwrapped = try? JSONSerialization.jsonObject(with: innerData) as? [String: Any],
           unwrapped["message"] != nil {
            object = unwrapped
        }
        
        if let content = (object["message"] ?? object["content"]) as? String, !content.isEmpty {
            onMessage?(MessageModel(sender: .stella, content: content))
        }
        if let rawTasks = object["tasks"] as? [Any], !rawTasks.isEmpty,
           let tasksData = try? JSONSerialization.data(withJSONObject: rawTasks),
           let tasks = try? decoder.decode([GeneratedTaskPayload].self, from: tasksData) {
            onTasks?(tasks.map { $0.toTaskModel() })
        }
    }
    
    private func handleFailure(_ error: Error?) {
        lastError = error?.localizedDescription ?? "Disconnected by the server"
        socket?.cancel(with: .goingAway, reason: nil)
        socket = nil
        status = .disconnected
        guard reconnectAttempts < maxReconnectAttempts else { return }
        reconnectAttempts += 1
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(2))
            guard self.shouldStayConnected else { return }
            self.connect(token: self.token)
        }
    }
}

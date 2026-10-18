//
//  MessageSocketController.swift
//  Project-Stella
//
//  Created by Mac-LAB on 10/14/26.
//

import SwiftUI

// Talks to the backend CompanionGateway, which runs Socket.IO.
// Socket.IO sits on top of a plain WebSocket, so this speaks its small text protocol directly:
// "0" open, "40" connected, "41" disconnected, "2"/"3" ping/pong, "42[event, data]" an event.
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
        // Accepts dates with or without milliseconds, same as getTasks
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
        // "41" tells the gateway this client is leaving
        socket?.send(.string("41")) { _ in }
        socket?.cancel(with: .normalClosure, reason: nil)
        socket = nil
        status = .disconnected
    }
    
    // Returns false when the socket is not connected so the page can fall back
    @discardableResult
    func send(_ message: MessageModel, userId: String?) -> Bool {
        guard status == .connected else { return false }
        let payload = OutgoingSocketMessage(id: userId ?? "", agent: agent, message: message.content)
        return emit(payload)
    }
    
    // Asks the summary agent for the dashboard's daily summary
    @discardableResult
    func requestSummary(userId: String?) -> Bool {
        let message = MessageModel(sender: .user, content: "Give me a short summary of my tasks and events today, with one recommendation.")
        return send(message, userId: userId)
    }
    
    // Builds ws(s)://host/socket.io/?EIO=4&transport=websocket from Core().socketUrl
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
    
    // Sends 42["event", payload]
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
                // Ignore callbacks from a socket that was already replaced or closed
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
            // Engine.IO is open, now join the default namespace
            task.send(.string("40")) { _ in }
        } else if packet == "2" {
            // The server pings every few seconds and drops clients that don't answer
            task.send(.string("3")) { _ in }
        }
    }
    
    // The gateway replies with the n8n response under the same event name
    private func handleEvent(_ json: String) {
        guard let data = json.data(using: .utf8),
              let array = try? JSONSerialization.jsonObject(with: data) as? [Any],
              array.count > 1,
              array[0] as? String == agent.eventName else { return }
        
        var body = array[1]
        // n8n can wrap the response in an array
        if let list = body as? [Any], let first = list.first {
            body = first
        }
        guard var object = body as? [String: Any] else { return }
        // The Respond to Webhook node can send {message, tasks} as a string inside message
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

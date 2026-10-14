//
//  SocketPayload.swift
//  Project-Stella
//
//  Created by Mac-LAB on 10/14/26.
//

import SwiftUI

// Which Stella agent a chat socket talks to
enum StellaAgent: String, Codable {
    case analyzer = "analyzer", generator = "generator"
}

enum SocketStatus {
    case disconnected, connecting, connected
}

// Placeholder: payload shapes until the backend WebSocket contract is decided
struct OutgoingSocketMessage: Encodable {
    var type: String = "message"
    var agent: StellaAgent
    var userId: String?
    var messageId: String
    var content: String
    var sentAt: Date
}

struct IncomingSocketMessage: Decodable {
    var type: String
    var messageId: String?
    var content: String?
    var sentAt: Date?
    var tasks: [GeneratedTaskPayload]?
}

// Mirrors the Task Generator output {tasks[], message}
struct GeneratedTaskPayload: Decodable {
    var title: String
    var description: String?
    var priority: String
    var complexity: String
    var startTime: Date
    var endTime: Date
    
    func toTaskModel() -> TaskModel {
        TaskModel(id: UUID().uuidString,
                  taskName: title,
                  taskDetail: description,
                  priority: Priority.allCases.first { $0.rawValue.lowercased() == priority.lowercased() } ?? .medium,
                  complexity: Complexity.allCases.first { $0.rawValue.lowercased() == complexity.lowercased() } ?? .medium,
                  startTime: startTime,
                  endTime: endTime)
    }
}

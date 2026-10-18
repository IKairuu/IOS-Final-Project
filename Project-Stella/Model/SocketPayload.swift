//
//  SocketPayload.swift
//  Project-Stella
//
//  Created by Mac-LAB on 10/14/26.
//

import SwiftUI

// Which Stella agent a socket talks to
nonisolated enum StellaAgent: String, Codable {
    case analyzer = "analyzer", generator = "generator", summary = "summary"
    
    // Socket.IO event name handled by the backend CompanionGateway
    var eventName: String {
        switch self {
        case .analyzer: return "analyze"
        case .generator: return "generate"
        case .summary: return "summary"
        }
    }
}

enum SocketStatus {
    case disconnected, connecting, connected
}

// Mirrors the backend companion Message DTO {id, agent, message}
nonisolated struct OutgoingSocketMessage: Encodable {
    var id: String
    var agent: StellaAgent
    var message: String
}

// Mirrors the Task Generator output {tasks[], message}
nonisolated struct GeneratedTaskPayload: Decodable {
    var title: String
    var description: String?
    var priority: String
    var complexity: String
    var startTime: Date
    var endTime: Date
    
    @MainActor func toTaskModel() -> TaskModel {
        TaskModel(id: UUID().uuidString,
                  taskName: title,
                  taskDetail: description,
                  priority: Priority.allCases.first { $0.rawValue.lowercased() == priority.lowercased() } ?? .medium,
                  complexity: Complexity.allCases.first { $0.rawValue.lowercased() == complexity.lowercased() } ?? .medium,
                  startTime: startTime,
                  endTime: endTime)
    }
}

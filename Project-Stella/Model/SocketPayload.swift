//
//  SocketPayload.swift
//  Project-Stella
//
//  Created by Mac-LAB on 10/14/26.
//

import SwiftUI

nonisolated enum StellaAgent: String, Codable {
    case analyzer = "analyzer", generator = "generator", summary = "summary"
    
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

nonisolated struct OutgoingSocketMessage: Encodable {
    var id: String
    var agent: StellaAgent
    var message: String
}

nonisolated struct GeneratedTaskPayload: Decodable {
    var eventId: String?
    var title: String
    var description: String?
    var priority: String
    var complexity: String
    var startTime: Date
    var endTime: Date
    
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyKey.self)
        eventId = try? c.first(String.self, ["event_id", "eventId"])
        title = try c.first(String.self, ["task_name", "taskName", "title"])
        description = try? c.first(String.self, ["task_detail", "taskDetail", "description"])
        priority = try c.first(String.self, ["priority"])
        complexity = try c.first(String.self, ["complexity"])
        startTime = try c.first(Date.self, ["start_time", "startTime"])
        endTime = try c.first(Date.self, ["end_time", "endTime"])
    }
    
    @MainActor func toTaskModel() -> TaskModel {
        var task = TaskModel(id: UUID().uuidString,
                             taskName: title,
                             taskDetail: description,
                             priority: Priority.allCases.first { $0.rawValue.lowercased() == priority.lowercased() } ?? .medium,
                             complexity: Complexity.allCases.first { $0.rawValue.lowercased() == complexity.lowercased() } ?? .medium,
                             startTime: startTime,
                             endTime: endTime)
        task.eventId = eventId?.isEmpty == false ? eventId : nil
        return task
    }
}

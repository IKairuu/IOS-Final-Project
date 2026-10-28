//
//  TaskDatasource.swift
//  Project-Stella
//
//  Created by Mac-LAB on 10/15/26.
//

import SwiftUI

struct TaskDatasource {
    nonisolated struct TaskResponse: Decodable {
        let id: String
        let eventId: String?
        let title: String
        let description: String?
        let priority: String
        let complexity: String
        let startTime: Date
        let endTime: Date

        init(from decoder: Decoder) throws {
            let c = try decoder.container(keyedBy: AnyKey.self)
            id = try c.first(String.self, ["id"])
            eventId = try? c.first(String.self, ["event_id", "eventId"])
            title = try c.first(String.self, ["task_name", "taskName", "title"])
            description = try? c.first(String.self, ["task_detail", "taskDetail", "description"])
            priority = try c.first(String.self, ["priority"])
            complexity = try c.first(String.self, ["complexity"])
            startTime = try c.first(Date.self, ["start_time", "startTime"])
            endTime = try c.first(Date.self, ["end_time", "endTime"])
        }

        @MainActor func toTaskModel() -> TaskModel {
            var task = TaskModel(id: id,
                                 taskName: title,
                                 taskDetail: description,
                                 priority: Priority.allCases.first { $0.rawValue.lowercased() == priority.lowercased() } ?? .medium,
                                 complexity: Complexity.allCases.first { $0.rawValue.lowercased() == complexity.lowercased() } ?? .medium,
                                 startTime: startTime,
                                 endTime: endTime)
            task.eventId = eventId
            return task
        }
    }

    private nonisolated struct WrappedTasks: Decodable {
        let tasks: [TaskResponse]?
        let data: [TaskResponse]?
    }

    func getTasks(token: String) async throws -> [TaskModel] {
        let url = URL(string: "\(Core().baseUrl)/tasks/v1")!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            print("getTasks failed: \(String(data: data, encoding: .utf8) ?? "")")
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom(TaskDatasource.decodeDate)

        do {
            let firstChar = String(decoding: data, as: UTF8.self).first { !$0.isWhitespace }
            if firstChar == "[" {
                return try decoder.decode([TaskResponse].self, from: data).map { $0.toTaskModel() }
            }
            let wrapped = try decoder.decode(WrappedTasks.self, from: data)
            return (wrapped.tasks ?? wrapped.data ?? []).map { $0.toTaskModel() }
        } catch {
            print("getTasks could not decode: \(String(data: data, encoding: .utf8) ?? "")")
            throw error
        }
    }

    nonisolated static func decodeDate(_ decoder: Decoder) throws -> Date {
        let text = try decoder.singleValueContainer().decode(String.self)
        let withFraction = ISO8601DateFormatter()
        withFraction.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = withFraction.date(from: text) ?? ISO8601DateFormatter().date(from: text) {
            return date
        }
        throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Invalid date: \(text)"))
    }
}

nonisolated struct AnyKey: CodingKey {
    var stringValue: String
    var intValue: Int? { nil }
    init(stringValue: String) { self.stringValue = stringValue }
    init?(intValue: Int) { return nil }
}

extension KeyedDecodingContainer where Key == AnyKey {
    nonisolated func first<T: Decodable>(_ type: T.Type, _ names: [String]) throws -> T {
        for name in names {
            let key = AnyKey(stringValue: name)
            if contains(key), (try? decodeNil(forKey: key)) == false {
                return try decode(T.self, forKey: key)
            }
        }
        throw DecodingError.keyNotFound(AnyKey(stringValue: names[0]),
                                        .init(codingPath: codingPath, debugDescription: "None of \(names) found"))
    }
}

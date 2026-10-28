//
//  EventDatasource.swift
//  Project-Stella
//
//  Created by Mac-LAB on 10/28/26.
//

import SwiftUI

struct EventDatasource {
    nonisolated struct EventResponse: Decodable {
        let id: String
        let title: String
        let description: String?
        let startTime: Date
        let endTime: Date

        init(from decoder: Decoder) throws {
            let c = try decoder.container(keyedBy: AnyKey.self)
            id = try c.first(String.self, ["id"])
            title = try c.first(String.self, ["title"])
            description = try? c.first(String.self, ["description"])
            startTime = try c.first(Date.self, ["start_time", "startTime"])
            endTime = try c.first(Date.self, ["end_time", "endTime"])
        }

        @MainActor func toEventModel() -> EventModel {
            EventModel(id: id, title: title, description: description, startTime: startTime, endTime: endTime)
        }
    }

    private nonisolated struct WrappedEvents: Decodable {
        let events: [EventResponse]?
        let data: [EventResponse]?
    }

    func getEvents(token: String) async throws -> [EventModel] {
        let url = URL(string: "\(Core().baseUrl)/events/v1")!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            print("getEvents failed: \(String(data: data, encoding: .utf8) ?? "")")
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom(TaskDatasource.decodeDate)

        do {
            let firstChar = String(decoding: data, as: UTF8.self).first { !$0.isWhitespace }
            if firstChar == "[" {
                return try decoder.decode([EventResponse].self, from: data).map { $0.toEventModel() }
            }
            let wrapped = try decoder.decode(WrappedEvents.self, from: data)
            return (wrapped.events ?? wrapped.data ?? []).map { $0.toEventModel() }
        } catch {
            print("getEvents could not decode: \(String(data: data, encoding: .utf8) ?? "")")
            throw error
        }
    }
}

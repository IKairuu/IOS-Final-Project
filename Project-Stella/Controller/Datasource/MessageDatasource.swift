//
//  MessageDatasource.swift
//  Project-Stella
//
//  Created by Mac-LAB on 10/28/26.
//

import SwiftUI

struct MessageDatasource {
    nonisolated struct MessageResponse: Decodable {
        let id: String
        let message: String
        let isUser: Bool
        let messageAt: Date

        init(from decoder: Decoder) throws {
            let c = try decoder.container(keyedBy: AnyKey.self)
            id = try c.first(String.self, ["id"])
            message = try c.first(String.self, ["message"])
            isUser = try c.first(Bool.self, ["is_user", "isUser"])
            messageAt = try c.first(Date.self, ["message_at", "messageAt"])
        }

        @MainActor func toMessageModel() -> MessageModel {
            MessageModel(id: id, sender: isUser ? .user : .stella, content: message, sentAt: messageAt)
        }
    }

    private nonisolated struct WrappedMessages: Decodable {
        let messages: [MessageResponse]?
        let data: [MessageResponse]?
    }

    func getMessages(token: String, agent: StellaAgent) async throws -> [MessageModel] {
        let url = URL(string: "\(Core().baseUrl)/messages/v1/\(agent.rawValue)")!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            print("getMessages(\(agent.rawValue)) failed: \(String(data: data, encoding: .utf8) ?? "")")
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom(TaskDatasource.decodeDate)

        let firstChar = String(decoding: data, as: UTF8.self).first { !$0.isWhitespace }
        let messages: [MessageResponse]
        if firstChar == "[" {
            messages = try decoder.decode([MessageResponse].self, from: data)
        } else {
            let wrapped = try decoder.decode(WrappedMessages.self, from: data)
            messages = wrapped.messages ?? wrapped.data ?? []
        }
        return messages.sorted { $0.messageAt < $1.messageAt }.map { $0.toMessageModel() }
    }
}

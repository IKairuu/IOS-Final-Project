//
//  SessionDatasource.swift
//  Project-Stella
//
//  Created by Mac-LAB on 10/28/26.
//

import SwiftUI

struct SessionDatasource {
    enum SessionError: Error {
        case rejected
        case unreachable
    }

    func verifySession(token: String) async throws -> UserModel {
        let url = URL(string: "\(Core().baseUrl)/sessions/v1/\(token)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        guard let result = try? await URLSession.shared.data(for: request) else {
            throw SessionError.unreachable
        }
        let (data, response) = result

        guard let httpResponse = response as? HTTPURLResponse else {
            throw SessionError.unreachable
        }
        if httpResponse.statusCode >= 500 {
            throw SessionError.unreachable
        }
        guard (200...299).contains(httpResponse.statusCode),
              let user = try? JSONDecoder().decode(UserModel.self, from: data) else {
            print("verifySession rejected: \(String(data: data, encoding: .utf8) ?? "")")
            throw SessionError.rejected
        }
        return user
    }

    func logoutSession(token: String) async {
        let url = URL(string: "\(Core().baseUrl)/sessions/v1/\(token)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        _ = try? await URLSession.shared.data(for: request)
    }
}

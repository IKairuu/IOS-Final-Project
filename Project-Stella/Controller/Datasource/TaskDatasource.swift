//
//  TaskDatasource.swift
//  Project-Stella
//
//  Created by Mac-LAB on 10/15/26.
//

import SwiftUI
struct TaskDatasource {
    func getTasks(token: String) async throws {
        let url = URL(string: "\(Core().baseUrl)/tasks/v1")!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        let result = try JSONDecoder().decode([String: String].self, from: data)

        print("In")
        print(result)
    }
}


//
//  AuthenticationDatasource.swift
//  Project-Stella
//
//  Created by Mac-LAB on 9/24/26.
//

import SwiftUI

struct AuthenticationDatasource {
    struct registerUserGoogleAccountRequest: Codable {
        let googleId: String
        let email: String
    }
    
    func registerUserGoogleAccount(googleUid: String, email: String) async throws -> String {
        let url = URL(string: "\(Core().baseUrl)/users/v1/google/register")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = registerUserGoogleAccountRequest(googleId: googleUid, email: email)
        
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode([String: String].self, from: data)
        return response["token"]!
    }
}

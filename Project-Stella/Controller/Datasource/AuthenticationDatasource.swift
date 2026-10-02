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
    
    struct registerUserRequest: Codable {
        let google_uid: String
        let email: String
        let username: String
        let password: String
        let occupation: String
    }
    
    struct loginUserRequest: Codable {
        let username: String
        let password: String?
        let google_uid: String?
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
    
    func registerUser(googleUid: String, email: String, username: String, password: String, occupation: String, token: String) async throws -> UserModel{
        let url = URL(string: "\(Core().baseUrl)/users/v1/google/register/\(token)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = registerUserRequest(google_uid: googleUid, email: email, username: username, password: password, occupation: occupation)
        
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(UserModel.self, from: data)
        return response
    }
    
    func loginUser(username: String?, password: String?, googleUid: String?, method: String) async throws -> UserModel{
        let url = URL(string: "\(Core().baseUrl)/users/v1/login?type=\(method)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = loginUserRequest(username: username ?? "None", password: password, google_uid: googleUid)
        
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(UserModel.self, from: data)
        return response
    }
}

//
//  User.swift
//  Project-Stella
//
//  Created by Mac-LAB on 9/8/26.
//

import SwiftUI
import SwiftData

@Model
final class UserModel: Identifiable {
    var id: UUID
    var email: String
    var username: String
    
    init(id: UUID = UUID(),email: String ,username: String) {
        self.id = id
        self.email = email
        self.username = username
    }
}

var testUser = UserModel(id: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440000")!, email: "abandia", username: "Kairu")

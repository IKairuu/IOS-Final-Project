//
//  User.swift
//  Project-Stella
//
//  Created by Mac-LAB on 9/8/26.
//

import SwiftUI

struct User: Identifiable {
    let id: UUID
    var email: String
    var username: String
}

var testUser = User(id: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440000")!, email: "abandia", username: "Kairu")

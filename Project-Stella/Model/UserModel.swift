//
//  User.swift
//  Project-Stella
//
//  Created by Mac-LAB on 9/8/26.
//

import SwiftUI
import SwiftData

struct UserModel: Decodable {
    var id: String
    var type: UserType
    var username: String
    var occupation: String
}

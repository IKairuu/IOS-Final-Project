//
//  AppState.swift
//  Project-Stella
//
//  Created by Mac-LAB on 9/24/26.
//

import SwiftUI

@Observable
class AppState {
    var token: String?
    var isLoggedIn: Bool = false
}

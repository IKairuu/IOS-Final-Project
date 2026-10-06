//
//  Complexity.swift
//  Project-Stella
//
//  Created by Mac-LAB on 9/10/26.
//

import SwiftUI

enum Complexity: String, CaseIterable, Identifiable {
    case easy = "Easy", medium = "Medium", hard = "Hard"
    
    var id: String { self.rawValue }
}

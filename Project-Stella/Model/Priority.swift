//
//  Priority.swift
//  Project-Stella
//
//  Created by Mac-LAB on 9/10/26.
//

import SwiftUI

enum Priority: String, CaseIterable, Identifiable {
    case low = "Low", medium = "Medium", high = "High"
    
    var id: String { self.rawValue }
}

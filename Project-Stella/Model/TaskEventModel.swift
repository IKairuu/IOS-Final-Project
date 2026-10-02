//
//  TaskEventModel.swift
//  Project-Stella
//
//  Created by Mac-LAB on 10/2/26.
//

import SwiftUI

struct TaskEventModel: Identifiable {
    var id: UUID
    var title: String
    var description: String?
    var startTime: Date
    var endTime: Date
    
    init(id: UUID, title: String, description: String?, startTime: Date, endTime: Date) {
        self.id = id
        self.title = title
        self.description = description
        self.startTime = startTime
        self.endTime = endTime
    }
}

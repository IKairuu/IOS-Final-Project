//
//  Event.swift
//  Project-Stella
//
//  Created by Mac-LAB on 9/10/26.
//

import SwiftUI
import SwiftData

struct EventModel: Identifiable, Hashable {
    var id: String
    var title: String
    var description: String?
    var startTime: Date
    var endTime: Date
    
    init(id: String, title: String, description: String? = nil, startTime: Date, endTime: Date){
        self.id = id
        self.title = title
        self.description = description
        self.startTime = startTime
        self.endTime = endTime
    }
}

var testEvents: [EventModel] = [EventModel(id: "550e8400-e29b-41d4-a716-446655440000",
                                 title: "Python Quiz",
                                 description: "Quiz",
                                 startTime: Calendar.current.date(from: DateComponents(year: 2026, month: 9, day: 13, hour: 12, minute: 30))!,
                                 endTime: Calendar.current.date(from: DateComponents(year: 2026, month: 9, day: 13, hour: 13, minute: 30))!),
                           EventModel(id: "550e8400-e29b-41d4-a716-446655490000",
                                title: "UI/UX Design Submission",
                                description: "Submission of STELLA design",
                                startTime: Calendar.current.date(from: DateComponents(year: 2026, month: 9, day: 15, hour: 15, minute: 30))!,
                                endTime: Calendar.current.date(from: DateComponents(year: 2026, month: 9, day: 15, hour: 16, minute: 30))!)]

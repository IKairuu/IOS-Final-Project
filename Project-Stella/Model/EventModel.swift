//
//  Event.swift
//  Project-Stella
//
//  Created by Mac-LAB on 9/10/26.
//

import SwiftUI
import SwiftData

final class EventModel: Identifiable {
    let id: UUID
    let title: String
    let description: String?
    let startTime: Date
    let endTime: Date
    
    init(id: UUID = UUID(), title: String, description: String? = nil, startTime: Date, endTime: Date){
        self.id = id
        self.title = title
        self.description = description
        self.startTime = startTime
        self.endTime = endTime
    }
}

let testEvents: [EventModel] = [EventModel(id: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440000")!,
                                 title: "Python Quiz",
                                 description: "Quiz",
                                 startTime: Calendar.current.date(from: DateComponents(year: 2026, month: 9, day: 13, hour: 12, minute: 30))!,
                                 endTime: Calendar.current.date(from: DateComponents(year: 2026, month: 9, day: 13, hour: 13, minute: 30))!),
                           EventModel(id: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440000")!,
                                title: "UI/UX Design Submission",
                                description: "Submission of STELLA design",
                                startTime: Calendar.current.date(from: DateComponents(year: 2026, month: 9, day: 15, hour: 15, minute: 30))!,
                                endTime: Calendar.current.date(from: DateComponents(year: 2026, month: 9, day: 15, hour: 16, minute: 30))!)]

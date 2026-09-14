//
//  Event.swift
//  Project-Stella
//
//  Created by Mac-LAB on 9/10/26.
//

import SwiftUI

struct Event: Identifiable {
    let id: UUID
    let title: String
    let description: String?
    let startTime: Date
    let endTime: Date
}

let testEvents: [Event] = [Event(id: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440000")!,
                                 title: "Python Quiz",
                                 description: "Quiz",
                                 startTime: Calendar.current.date(from: DateComponents(year: 2026, month: 9, day: 13, hour: 12, minute: 30))!,
                                 endTime: Calendar.current.date(from: DateComponents(year: 2026, month: 9, day: 13, hour: 13, minute: 30))!),
                           Event(id: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440000")!,
                                title: "UI/UX Design Submission",
                                description: "Submission of STELLA design",
                                startTime: Calendar.current.date(from: DateComponents(year: 2026, month: 9, day: 15, hour: 15, minute: 30))!,
                                endTime: Calendar.current.date(from: DateComponents(year: 2026, month: 9, day: 15, hour: 16, minute: 30))!)]

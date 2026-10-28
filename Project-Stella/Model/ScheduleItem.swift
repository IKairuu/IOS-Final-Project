//
//  ScheduleItem.swift
//  Project-Stella
//
//  Created by Mac-LAB on 10/28/26.
//

import SwiftUI

enum ScheduleItem: Identifiable {
    case event(EventModel)
    case task(TaskModel)

    var id: String {
        switch self {
        case .event(let event): return "event-\(event.id)"
        case .task(let task): return "task-\(task.id)"
        }
    }

    var startTime: Date {
        switch self {
        case .event(let event): return event.startTime
        case .task(let task): return task.startTime
        }
    }
}

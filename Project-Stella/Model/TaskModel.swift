//
//  Task.swift
//  Project-Stella
//
//  Created by Mac-LAB on 9/8/26.
//

import SwiftUI
import SwiftData

final class TaskModel: Identifiable {
    var id: UUID
    var eventId: String?
    var taskName: String
    var taskDetail: String?
    var priority: Priority
    var complexity: Complexity
    var startTime: Date
    var endTime: Date
    
    init(id: UUID = UUID(), taskName: String, taskDetail: String? = nil, priority: Priority, complexity: Complexity, startTime: Date, endTime: Date){
        self.id = id
        self.taskName = taskName
        self.taskDetail = taskDetail
        self.priority = priority
        self.complexity = complexity
        self.startTime = startTime
        self.endTime = endTime
    }
}

var testTask: [TaskModel] = [
    TaskModel(id: UUID(uuidString: "550e8400-e28b-41d4-a716-446655440000")!,
         taskName: "Review Python",
         priority: Priority.medium,
         complexity: Complexity.easy,
         startTime: Calendar.current.date(from: DateComponents(year: 2026, month: 9, day: 15, hour: 12, minute: 30))!,
         endTime: Calendar.current.date(from: DateComponents(year: 2026, month: 9, day: 15, hour: 14, minute: 0))!),
    TaskModel(id: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440000")!,
         taskName: "STELLA UI/UX Design making",
         priority: Priority.low,
         complexity: Complexity.hard,
         startTime: Calendar.current.date(from: DateComponents(year: 2026, month: 9, day: 11, hour: 12, minute: 30))!,
         endTime: Calendar.current.date(from: DateComponents(year: 2026, month: 9, day: 11, hour: 15, minute: 30))!),
    TaskModel(id: UUID(uuidString: "550e8400-e30b-41d4-a716-446655440000")!,
         taskName: "STELLA UI/UX Design making",
         priority: Priority.low,
         complexity: Complexity.hard,
         startTime: Calendar.current.date(from: DateComponents(year: 2026, month: 9, day: 12, hour: 12, minute: 30))!,
         endTime: Calendar.current.date(from: DateComponents(year: 2026, month: 9, day: 12, hour: 13, minute: 30))!)]



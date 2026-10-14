//
//  Task.swift
//  Project-Stella
//
//  Created by Mac-LAB on 9/8/26.
//

import SwiftUI
import SwiftData

struct TaskModel: Identifiable {
    var id: String
    var eventId: String?
    var title: String
    var description: String?
    var priority: Priority
    var complexity: Complexity
    var startTime: Date
    var endTime: Date
    
    init(id: String, taskName: String, taskDetail: String? = nil, priority: Priority, complexity: Complexity, startTime: Date, endTime: Date){
        self.id = id
        self.title = taskName
        self.description = taskDetail
        self.priority = priority
        self.complexity = complexity
        self.startTime = startTime
        self.endTime = endTime
    }
}

var testTask: [TaskModel] = [
    TaskModel(id: "550e8400-e28b-41d4-a716-446655440000",
         taskName: "Review Python",
         priority: Priority.medium,
         complexity: Complexity.easy,
         startTime: Calendar.current.date(from: DateComponents(year: 2026, month: 9, day: 15, hour: 12, minute: 30))!,
         endTime: Calendar.current.date(from: DateComponents(year: 2026, month: 9, day: 15, hour: 14, minute: 0))!),
    TaskModel(id: "550e8400-e29b-41d4-a716-446655440000",
         taskName: "STELLA UI/UX Design making",
         priority: Priority.low,
         complexity: Complexity.hard,
         startTime: Calendar.current.date(from: DateComponents(year: 2026, month: 9, day: 11, hour: 12, minute: 30))!,
         endTime: Calendar.current.date(from: DateComponents(year: 2026, month: 9, day: 11, hour: 15, minute: 30))!),
    TaskModel(id: "550e8400-e30b-41d4-a716-446655440000",
         taskName: "STELLA UI/UX Design making",
         priority: Priority.low,
         complexity: Complexity.hard,
         startTime: Calendar.current.date(from: DateComponents(year: 2026, month: 9, day: 12, hour: 12, minute: 30))!,
         endTime: Calendar.current.date(from: DateComponents(year: 2026, month: 9, day: 12, hour: 13, minute: 30))!)]


var testGeneratedTasks: [TaskModel] = [
    TaskModel(id: "7c9e6679-7425-40de-944b-e07fc1f90ae1",
         taskName: "Python Quiz – Review Key Concepts",
         taskDetail: "Go over loops, functions, and lists before the quiz",
         priority: Priority.high,
         complexity: Complexity.medium,
         startTime: Calendar.current.date(from: DateComponents(year: 2026, month: 5, day: 28, hour: 19, minute: 0))!,
         endTime: Calendar.current.date(from: DateComponents(year: 2026, month: 5, day: 28, hour: 20, minute: 0))!),
    TaskModel(id: "7c9e6679-7425-40de-944b-e07fc1f90ae2",
         taskName: "Python Quiz – Practice Questions",
         taskDetail: "Answer practice questions and check mistakes",
         priority: Priority.high,
         complexity: Complexity.medium,
         startTime: Calendar.current.date(from: DateComponents(year: 2026, month: 5, day: 29, hour: 19, minute: 0))!,
         endTime: Calendar.current.date(from: DateComponents(year: 2026, month: 5, day: 29, hour: 20, minute: 30))!),
    TaskModel(id: "7c9e6679-7425-40de-944b-e07fc1f90ae3",
         taskName: "UI/UX – Research & Inspiration",
         taskDetail: "Collect reference designs for the STELLA screens",
         priority: Priority.medium,
         complexity: Complexity.easy,
         startTime: Calendar.current.date(from: DateComponents(year: 2026, month: 5, day: 30, hour: 14, minute: 0))!,
         endTime: Calendar.current.date(from: DateComponents(year: 2026, month: 5, day: 30, hour: 15, minute: 30))!),
    TaskModel(id: "7c9e6679-7425-40de-944b-e07fc1f90ae4",
         taskName: "UI/UX – Design Wireframes",
         taskDetail: "Sketch wireframes for the main pages",
         priority: Priority.medium,
         complexity: Complexity.medium,
         startTime: Calendar.current.date(from: DateComponents(year: 2026, month: 5, day: 31, hour: 14, minute: 0))!,
         endTime: Calendar.current.date(from: DateComponents(year: 2026, month: 5, day: 31, hour: 16, minute: 0))!),
    TaskModel(id: "7c9e6679-7425-40de-944b-e07fc1f90ae5",
         taskName: "UI/UX – Finalize & Prepare Submission",
         taskDetail: "Polish the final design and export the files",
         priority: Priority.high,
         complexity: Complexity.hard,
         startTime: Calendar.current.date(from: DateComponents(year: 2026, month: 6, day: 1, hour: 19, minute: 0))!,
         endTime: Calendar.current.date(from: DateComponents(year: 2026, month: 6, day: 1, hour: 21, minute: 0))!)]

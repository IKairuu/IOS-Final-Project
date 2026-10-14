//
//  TaskController.swift
//  Project-Stella
//
//  Created by Mac-LAB on 10/13/26.
//
import SwiftUI
internal import Combine

final class TaskController: ObservableObject {
    // Placeholder: saves to the local test data until the backend is wired in.
    // Returns an error message, or nil when the task was added.
    func addTask(taskName: String, taskDescription: String, startTime: Date, endTime: Date, priority: Priority, complexity: Complexity) -> String? {
        let name = taskName.trimmingCharacters(in: .whitespacesAndNewlines)
        if name.isEmpty {
            return "Please enter a task name."
        }
        if endTime <= startTime {
            return "The end time must be after the start time."
        }
        let detail = taskDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        let newTask = TaskModel(id: UUID().uuidString, taskName: name, taskDetail: detail.isEmpty ? nil : detail, priority: priority, complexity: complexity, startTime: startTime, endTime: endTime)
        testTask.append(newTask)
        return nil
    }
}

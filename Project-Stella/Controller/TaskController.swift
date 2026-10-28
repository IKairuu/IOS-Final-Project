//
//  TaskController.swift
//  Project-Stella
//
//  Created by Mac-LAB on 10/13/26.
//
import SwiftUI
internal import Combine

final class TaskController: ObservableObject {
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
    
    func updateTask(taskId: String, taskName: String, taskDescription: String, startTime: Date, endTime: Date, priority: Priority, complexity: Complexity) -> String? {
        let name = taskName.trimmingCharacters(in: .whitespacesAndNewlines)
        if name.isEmpty {
            return "Please enter a task name."
        }
        if endTime <= startTime {
            return "The end time must be after the start time."
        }
        guard let index = testTask.firstIndex(where: { $0.id == taskId }) else {
            return "This task no longer exists."
        }
        let detail = taskDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        testTask[index].title = name
        testTask[index].description = detail.isEmpty ? nil : detail
        testTask[index].startTime = startTime
        testTask[index].endTime = endTime
        testTask[index].priority = priority
        testTask[index].complexity = complexity
        return nil
    }
}

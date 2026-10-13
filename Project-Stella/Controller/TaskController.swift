//
//  TaskController.swift
//  Project-Stella
//
//  Created by Mac-LAB on 10/13/26.
//
import SwiftUI
internal import Combine

final class TaskController: ObservableObject {
    func addTask(taskName: String, taskDescription: String, startTime: Date, endTime: Date, priority: Priority, complexity: Complexity) {
        let newTask = TaskModel(id: "Test", taskName: taskName, taskDetail: taskDescription, priority: priority, complexity: complexity, startTime: startTime, endTime: endTime)
        testTask.append(newTask)
    }
}

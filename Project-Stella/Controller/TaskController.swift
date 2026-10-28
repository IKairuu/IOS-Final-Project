//
//  TaskController.swift
//  Project-Stella
//
//  Created by Mac-LAB on 10/13/26.
//
import SwiftUI
internal import Combine

final class TaskController: ObservableObject {
    func addTask(token: String?, taskName: String, taskDescription: String, startTime: Date, endTime: Date, priority: Priority, complexity: Complexity) async -> String? {
        let name = taskName.trimmingCharacters(in: .whitespacesAndNewlines)
        if name.isEmpty {
            return "Please enter a task name."
        }
        if endTime <= startTime {
            return "The end time must be after the start time."
        }
        guard let token else {
            return "You are not logged in."
        }
        let detail = taskDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        let body = TaskDatasource.TaskRequest(id: nil,
                                              event_id: nil,
                                              task_name: name,
                                              task_detail: detail.isEmpty ? nil : detail,
                                              priority: priority.rawValue.lowercased(),
                                              complexity: complexity.rawValue.lowercased(),
                                              start_time: TaskDatasource.isoString(startTime),
                                              end_time: TaskDatasource.isoString(endTime))
        do {
            try await TaskDatasource().createTask(token: token, body: body)
            testTask = try await TaskDatasource().getTasks(token: token)
            return nil
        } catch {
            return "Could not save the task. Please try again."
        }
    }
    
    func updateTask(token: String?, taskId: String, taskName: String, taskDescription: String, startTime: Date, endTime: Date, priority: Priority, complexity: Complexity) async -> String? {
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
        guard let token else {
            return "You are not logged in."
        }
        let detail = taskDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        let body = TaskDatasource.TaskRequest(id: taskId,
                                              event_id: testTask[index].eventId,
                                              task_name: name,
                                              task_detail: detail.isEmpty ? nil : detail,
                                              priority: priority.rawValue.lowercased(),
                                              complexity: complexity.rawValue.lowercased(),
                                              start_time: TaskDatasource.isoString(startTime),
                                              end_time: TaskDatasource.isoString(endTime))
        do {
            try await TaskDatasource().editTask(token: token, body: body)
            testTask = try await TaskDatasource().getTasks(token: token)
            return nil
        } catch {
            return "Could not update the task. Please try again."
        }
    }
    
    func deleteTasks(token: String?, ids: [String]) async -> String? {
        guard !ids.isEmpty else { return nil }
        let backup = testTask
        testTask.removeAll { ids.contains($0.id) }
        guard let token else {
            testTask = backup
            return "You are not logged in."
        }
        do {
            for id in ids {
                try await TaskDatasource().deleteTask(token: token, id: id)
            }
            testTask = try await TaskDatasource().getTasks(token: token)
            return nil
        } catch {
            testTask = (try? await TaskDatasource().getTasks(token: token)) ?? backup
            return "Could not delete the task. Please try again."
        }
    }
}

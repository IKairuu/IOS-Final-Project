//
//  Filter.swift
//  Project-Stella
//
//  Created by Mac-LAB on 10/2/26.
//

import SwiftUI

struct Filter {
    func filterAll() -> [TaskEventModel] {
        var list: [TaskEventModel] = []
        for tasks in testTask {
            list.append(TaskEventModel(id: tasks.id, title: tasks.title, description: tasks.description, startTime: tasks.startTime, endTime: tasks.endTime))
        }
        
        for events in testEvents {
            list.append(TaskEventModel(id: events.id, title: events.title, description: events.description, startTime: events.startTime, endTime: events.endTime))
        }
        return  list
    }
    
    func filterTask() -> [TaskModel] {
        var list: [TaskModel] = []
        for task in testTask {
            list.append(task)
        }
        return list
    }
    func filterEvent() -> [EventModel] {
        var list: [EventModel] = []
        for events in testEvents {
            list.append(events)
        }
        return list
    }
}

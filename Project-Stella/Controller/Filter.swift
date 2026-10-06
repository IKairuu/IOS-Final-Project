//
//  Filter.swift
//  Project-Stella
//
//  Created by Mac-LAB on 10/2/26.
//

import SwiftUI

struct Filter {
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

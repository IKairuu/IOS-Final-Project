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
    
    func combine(date: Date, time: Date) -> Date {
        let cal = Calendar.current
        let d = cal.dateComponents([.year, .month, .day], from: date)
        let t = cal.dateComponents([.hour, .minute], from: time)
        
        return cal.date(from: DateComponents(year: d.year, month: d.month, day: d.day, hour: t.hour, minute: t.minute)) ?? date
    }
}

//
//  Filter.swift
//  Project-Stella
//
//  Created by Mac-LAB on 10/2/26.
//

import SwiftUI

struct Filter {
    func filterTask(on date: Date = Date()) -> [TaskModel] {
        testTask
            .filter { isOnDay(start: $0.startTime, end: $0.endTime, date: date) }
            .sorted { $0.startTime < $1.startTime }
    }

    func filterEvent(on date: Date = Date()) -> [EventModel] {
        testEvents
            .filter { isOnDay(start: $0.startTime, end: $0.endTime, date: date) }
            .sorted { $0.startTime < $1.startTime }
    }

    func filterAll(on date: Date = Date()) -> [ScheduleItem] {
        let events = filterEvent(on: date).map { ScheduleItem.event($0) }
        let tasks = filterTask(on: date).map { ScheduleItem.task($0) }
        return (events + tasks).sorted { $0.startTime < $1.startTime }
    }

    private func isOnDay(start: Date, end: Date, date: Date) -> Bool {
        let calendar = Calendar.current
        let dayStart = calendar.startOfDay(for: date)
        let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart) ?? dayStart
        return (start < dayEnd && end > dayStart) || calendar.isDate(start, inSameDayAs: date)
    }

    func combine(date: Date, time: Date) -> Date {
        let cal = Calendar.current
        let d = cal.dateComponents([.year, .month, .day], from: date)
        let t = cal.dateComponents([.hour, .minute], from: time)
        
        return cal.date(from: DateComponents(year: d.year, month: d.month, day: d.day, hour: t.hour, minute: t.minute)) ?? date
    }
}

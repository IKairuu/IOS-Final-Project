import SwiftUI


struct StatisticsController {
    func priorityStatistics() -> [String: Int]{
        let lowTasks: Int = testTask.filter {$0.priority == Priority.low}.count
        let mediumTasks: Int = testTask.filter {$0.priority == Priority.medium}.count
        let highTasks: Int = testTask.filter {$0.priority == Priority.high}.count
        
        return ["Low": lowTasks, "Medium": mediumTasks, "High": highTasks]
    }
    
    func complexityStatistics() -> [String: Int] {
        let easyTasks: Int = testTask.filter {$0.complexity == Complexity.easy}.count
        let mediumTasks: Int = testTask.filter {$0.complexity == Complexity.medium}.count
        let hardTasks: Int = testTask.filter {$0.complexity == Complexity.hard}.count
        
        return ["Easy": easyTasks, "Medium": mediumTasks, "Hard": hardTasks]
    }
    
    func weeklyWorkload(tasks: [TaskModel] = testTask, now: Date = Date()) -> [String: [String: Any]] {
        let calendar = Calendar.current
        let dayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        guard let week = calendar.dateInterval(of: .weekOfYear, for: now) else { return [:] }
        var slices: [Int: [DateInterval]] = [:]
        for task in tasks where task.endTime > task.startTime {
            var cursor = max(task.startTime, week.start)
            let end = min(task.endTime, week.end)
            while cursor < end {
                let nextDay = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: cursor)) ?? end
                let sliceEnd = min(nextDay, end)
                slices[calendar.component(.weekday, from: cursor), default: []].append(DateInterval(start: cursor, end: sliceEnd))
                cursor = sliceEnd
            }
        }
        var result: [String: [String: Any]] = [:]
        for weekday in 1...7 {
            let workload = busyHours(slices[weekday] ?? [])
            result["\(weekday)"] = ["Day": dayNames[weekday - 1], "Vacancy": max(24 - workload, 0), "Workload": workload]
        }
        return result
    }

    private func busyHours(_ slices: [DateInterval]) -> Double {
        var total: TimeInterval = 0
        var current: DateInterval?
        for slice in slices.sorted(by: { $0.start < $1.start }) {
            if let active = current, slice.start <= active.end {
                current = DateInterval(start: active.start, end: max(active.end, slice.end))
            } else {
                if let active = current {
                    total += active.duration
                }
                current = slice
            }
        }
        if let active = current {
            total += active.duration
        }
        return min((total / 3600 * 100).rounded() / 100, 24)
    }
}

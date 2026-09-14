//
//  StatisticsController.swift
//  Project-Stella
//
//  Created by Mac-LAB on 9/10/26.
//

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
    
    func weeklyWorkload() -> [String: [String: Any]] {
        let weekDayGroup = Dictionary(grouping: testTask){ task in
            Calendar.current.component(.weekday, from: task.startTime)
        }
        var result: [String: [String: Any]] =
        [
            "1": ["Day": "Sun", "Vacancy": 24.0, "Workload": 0.0],
            "2": ["Day": "Mon", "Vacancy": 24.0, "Workload": 0.0],
            "3": ["Day": "Tue", "Vacancy": 24.0, "Workload": 0.0],
            "4": ["Day": "Wed", "Vacancy": 24.0, "Workload": 0.0],
            "5": ["Day": "Thu", "Vacancy": 24.0, "Workload": 0.0],
            "6": ["Day": "Fri", "Vacancy": 24.0, "Workload": 0.0],
            "7": ["Day": "Sat", "Vacancy": 24.0, "Workload": 0.0],]
        
        for (dayNum, val) in weekDayGroup {
            var workload = 0.0
            for dayVals in val {
                let diffSec = Int(dayVals.endTime.timeIntervalSince(dayVals.startTime))
                let hours = Double(diffSec / 3600)
                let minutes = Double((diffSec % 3600) / 60) * 0.01
                workload += Double(hours + minutes)
                if let current = result["\(dayNum)"]?["Vacancy"] as? Double {
                    result["\(dayNum)"]?["Vacancy"] = current - workload
                }
            }
            result["\(dayNum)"]?["Workload"] = workload
        }
        return result
    }
}


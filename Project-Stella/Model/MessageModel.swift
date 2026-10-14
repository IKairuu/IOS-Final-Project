//
//  MessageModel.swift
//  Project-Stella
//
//  Created by Mac-LAB on 10/14/26.
//

import SwiftUI

enum MessageSender: String {
    case user = "user", stella = "stella"
}

struct MessageModel: Identifiable, Hashable {
    var id: String
    var sender: MessageSender
    var content: String
    var sentAt: Date
    
    init(id: String = UUID().uuidString, sender: MessageSender, content: String, sentAt: Date = Date()){
        self.id = id
        self.sender = sender
        self.content = content
        self.sentAt = sentAt
    }
}

let testAnalyzerMessages: [MessageModel] = [
    MessageModel(id: "a1f0c2d4-0001-4c1e-9a10-000000000001",
                 sender: MessageSender.user,
                 content: "Can you check my upcoming tasks and help me organize them?",
                 sentAt: Calendar.current.date(bySettingHour: 12, minute: 30, second: 0, of: Date())!),
    MessageModel(id: "a1f0c2d4-0001-4c1e-9a10-000000000002",
                 sender: MessageSender.stella,
                 content: """
                 Of course! Let me analyze your current workload. 🔍 I found 5 upcoming tasks in your academic schedule.
                 📊 Workload Analysis
                 • 🟢 Python Quiz — Friday — High priority
                 • 🔴 UI/UX Design — Wednesday — Low priority
                 Based on your deadlines, priority, and estimated workload, your UI/UX Design. You currently have 3 available study periods before your earliest deadline.
                 """,
                 sentAt: Calendar.current.date(bySettingHour: 12, minute: 31, second: 0, of: Date())!),
    MessageModel(id: "a1f0c2d4-0001-4c1e-9a10-000000000003",
                 sender: MessageSender.user,
                 content: "Is my workload manageable?",
                 sentAt: Calendar.current.date(bySettingHour: 12, minute: 34, second: 0, of: Date())!),
    MessageModel(id: "a1f0c2d4-0001-4c1e-9a10-000000000004",
                 sender: MessageSender.stella,
                 content: """
                 Yes. Your workload is manageable, but your schedule is slightly concentrated around the next few deadlines.
                 I recommend starting with the UI/UX Design today and gradually reviewing your Python Quiz
                 """,
                 sentAt: Calendar.current.date(bySettingHour: 12, minute: 35, second: 0, of: Date())!)]

let testGeneratorMessages: [MessageModel] = [
    MessageModel(id: "b2e1d3c5-0002-4d2f-8b20-000000000001",
                 sender: MessageSender.user,
                 content: "can you organize my tasks for the next few days?",
                 sentAt: Calendar.current.date(bySettingHour: 13, minute: 30, second: 0, of: Date())!),
    MessageModel(id: "b2e1d3c5-0002-4d2f-8b20-000000000002",
                 sender: MessageSender.stella,
                 content: """
                 Sure! Let me check your upcoming events and available time.
                 
                 I found these upcoming events:
                 📘 Python Quiz
                 Friday · 01:00 PM
                 🎨 UI/UX Design Submission
                 Monday · 10:00 PM
                 You have 3 days between your Python Quiz and UI/UX submission.
                 """,
                 sentAt: Calendar.current.date(bySettingHour: 13, minute: 32, second: 0, of: Date())!)]

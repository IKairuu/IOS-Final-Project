//
//  StellaGeneratorPage.swift
//  Project-Stella
//
//  Created by Mac-LAB on 10/14/26.
//

import SwiftUI

struct StellaGeneratorPage: View {
    @Environment(AppState.self) private var appState
    @State private var messages: [MessageModel] = testGeneratorMessages
    @State private var generatedTasks: [TaskModel] = testGeneratedTasks
    @State private var input: String = ""
    var body: some View {
        VStack(spacing: 15) {
            VStack(spacing: 0) {
                ChatMessageList(messages: messages, initials: userInitials(appState.currentUser?.username))
                ChatInputBar(text: $input, onSend: sendMessage)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Design().secondaryColor)
            .cornerRadius(15)
            
            GeneratedTasksTable(tasks: generatedTasks, onConfirm: confirmTasks)
        }
    }
    
    // Placeholder: appends the message locally until the Task Generator agent is wired in
    private func sendMessage() {
        let content = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !content.isEmpty else { return }
        messages.append(MessageModel(sender: .user, content: content))
        input = ""
    }
    
    // Placeholder: saving confirmed tasks is not wired to the backend yet
    private func confirmTasks() {
        generatedTasks.removeAll()
    }
}

struct GeneratedTasksTable: View {
    let tasks: [TaskModel]
    let onConfirm: () -> Void
    
    private let nameWidth: CGFloat = 130
    private let detailWidth: CGFloat = 150
    private let timeWidth: CGFloat = 95
    private let badgeWidth: CGFloat = 85
    
    var body: some View {
        VStack(spacing: 10) {
            ScrollView([.horizontal, .vertical]) {
                VStack(spacing: 0) {
                    HStack(spacing: 8) {
                        TableHeader(label: "Task Name", icon: "list.bullet.rectangle", width: nameWidth)
                        TableHeader(label: "Details", icon: "text.alignleft", width: detailWidth)
                        TableHeader(label: "Start Time", icon: "clock", width: timeWidth)
                        TableHeader(label: "End Time", icon: "clock", width: timeWidth)
                        TableHeader(label: "Complexity", icon: "chart.bar.fill", width: badgeWidth)
                        TableHeader(label: "Priority", icon: "star.fill", width: badgeWidth)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 8)
                    .background(Design().mainTheme.opacity(0.35))
                    
                    if tasks.isEmpty {
                        Text("There are no generated Tasks")
                            .font(.custom("Roboto-Regular", size: 12))
                            .foregroundColor(.gray)
                            .padding(20)
                    }
                    ForEach(tasks) { task in
                        HStack(spacing: 8) {
                            Text(task.title)
                                .font(.custom("Roboto-Medium", size: 11))
                                .frame(width: nameWidth, alignment: .leading)
                            Text(task.description ?? "No details")
                                .font(.custom("Roboto-Regular", size: 11))
                                .foregroundColor(.gray)
                                .frame(width: detailWidth, alignment: .leading)
                            TaskTimeCell(date: task.startTime, width: timeWidth)
                            TaskTimeCell(date: task.endTime, width: timeWidth)
                            ComplexityBadge(complexity: task.complexity)
                                .frame(width: badgeWidth, alignment: .leading)
                            PriorityBadge(priority: task.priority)
                                .frame(width: badgeWidth, alignment: .leading)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 8)
                        Divider()
                    }
                }
                .background(Color.white)
                .cornerRadius(10)
            }
            .frame(height: 200)
            
            Button(action: onConfirm) {
                Text("CONFIRM")
                    .font(.custom("Roboto-Bold", size: 16))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Design().mainTheme)
                    .cornerRadius(10)
            }
            .disabled(tasks.isEmpty)
        }
        .padding(10)
        .background(Design().secondaryColor)
        .cornerRadius(15)
    }
}

struct TableHeader: View {
    let label: String
    let icon: String
    let width: CGFloat
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
            Text(label)
        }
        .font(.custom("Roboto-Medium", size: 10))
        .foregroundColor(.black)
        .frame(width: width, alignment: .leading)
    }
}

struct TaskTimeCell: View {
    let date: Date
    let width: CGFloat
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Label(date.formatted(.dateTime.weekday(.abbreviated).month(.abbreviated).day()), systemImage: "calendar")
            Label(date.formatted(.dateTime.hour(.defaultDigits(amPM: .abbreviated)).minute(.twoDigits)), systemImage: "clock")
        }
        .font(.custom("Roboto-Regular", size: 10))
        .foregroundColor(.black)
        .frame(width: width, alignment: .leading)
    }
}

struct TaskBadge: View {
    let label: String
    let icon: String
    let color: Color
    var body: some View {
        HStack(spacing: 3) {
            Image(systemName: icon)
            Text(label)
        }
        .font(.custom("Roboto-Medium", size: 10))
        .foregroundColor(color)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(color.opacity(0.15))
        .cornerRadius(6)
    }
}

struct ComplexityBadge: View {
    let complexity: Complexity
    var body: some View {
        switch complexity {
        case .easy: TaskBadge(label: complexity.rawValue, icon: "chart.bar.fill", color: .green)
        case .medium: TaskBadge(label: complexity.rawValue, icon: "chart.bar.fill", color: .orange)
        case .hard: TaskBadge(label: complexity.rawValue, icon: "chart.bar.fill", color: .red)
        }
    }
}

struct PriorityBadge: View {
    let priority: Priority
    var body: some View {
        switch priority {
        case .low: TaskBadge(label: priority.rawValue, icon: "flag.fill", color: .green)
        case .medium: TaskBadge(label: priority.rawValue, icon: "flag.fill", color: .orange)
        case .high: TaskBadge(label: priority.rawValue, icon: "flag.fill", color: .red)
        }
    }
}

#Preview {
    StellaGeneratorPage()
        .environment(AppState())
        .padding(20)
}

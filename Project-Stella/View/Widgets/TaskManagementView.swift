//
//  TaskManagementView.swift
//  Project-Stella
//
//  Created by Mac-LAB on 10/13/26.
//
import SwiftUI

struct TaskManagementView: View {
    @Environment(\.dismiss) private var dismiss
    let task: TaskModel
    @State private var errorMessage: String?
    @State private var showSaved: Bool = false
    @State private var selectedStartDate: Date
    @State private var selectedEndDate: Date
    @State private var taskName: String
    @State private var taskDescription: String
    @State private var selectedPriority: Priority
    @State private var selectedComplexity: Complexity

    init(task: TaskModel) {
        self.task = task
        _selectedStartDate = State(initialValue: task.startTime)
        _selectedEndDate = State(initialValue: task.endTime)
        _taskName = State(initialValue: task.title)
        _taskDescription = State(initialValue: task.description ?? "")
        _selectedPriority = State(initialValue: task.priority)
        _selectedComplexity = State(initialValue: task.complexity)
    }

    var body: some View {
        ScrollView {
            VStack {
                ScheduleSection(startDate: $selectedStartDate, endDate: $selectedEndDate)
                    .padding(.horizontal, 10)
                VStack(alignment: .leading) {
                    Text("TASK NAME")
                        .fontWeight(.bold)
                    TextField("Enter task name", text: $taskName)
                        .padding(10)
                        .background(Color(red: 242/255, green: 242/255, blue: 247/255))
                        .cornerRadius(15)
                }
                .padding(.horizontal, 10)
                .padding(.top, 10)
                VStack(alignment: .leading) {
                    Text("TASK DESCRIPTION")
                        .fontWeight(.bold)
                    TextField("Enter task description", text: $taskDescription, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                        .padding(10)
                        .background(Color(red: 242/255, green: 242/255, blue: 247/255))
                        .cornerRadius(15)
                }
                .padding(10)
                HStack {
                    VStack(alignment: .leading) {
                        Text("COMPLEXITY")
                            .fontWeight(.bold)
                        Picker("Choose complexity", selection: $selectedComplexity) {
                            ForEach(Complexity.allCases) { items in
                                Text(items.rawValue)
                                    .tag(items)
                                Spacer()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 242/255, green: 242/255, blue: 247/255))
                        .cornerRadius(20)
                    }
                    VStack(alignment: .leading) {
                        Text("PRIORITY")
                            .fontWeight(.bold)
                        Picker("Choose priority", selection: $selectedPriority) {
                            ForEach(Priority.allCases) { items in
                                Text(items.rawValue)
                                    .tag(items)
                                Spacer()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 242/255, green: 242/255, blue: 247/255))
                        .cornerRadius(20)
                    }

                }
                .padding(.horizontal, 10)
                .padding(.top, 10)

                Button {
                    errorMessage = TaskController().updateTask(taskId: task.id, taskName: taskName, taskDescription: taskDescription, startTime: selectedStartDate, endTime: selectedEndDate, priority: selectedPriority, complexity: selectedComplexity)
                    if errorMessage == nil {
                        showSaved = true
                    }
                } label: {
                    Text("SAVE CHANGES")
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Design().mainTheme)
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.4), radius: 5, x: 0, y: 5)
                }
            }
            .padding(20)

        }
        .navigationTitle("Edit Task")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Task updated", isPresented: $showSaved) {
            Button("OK") { dismiss() }
        } message: {
            Text("\(taskName) was updated.")
        }
        .alert("Can't update task", isPresented: Binding(get: { errorMessage != nil }, set: { if !$0 { errorMessage = nil } })) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage ?? "")
        }
    }
}

#Preview {
    NavigationStack {
        TaskManagementView(task: testTask[0])
    }
}

//
//  TaskManagementView.swift
//  Project-Stella
//
//  Created by Mac-LAB on 10/13/26.
//
import SwiftUI

struct TaskManagementView: View {
    @Binding var selectedTask: TaskModel
    var body: some View {
        ScrollView {
            VStack {
                DatePicker(
                    "Select Date",
                    selection: $selectedTask.startTime,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .background(Design().secondaryColor)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.4), radius: 5, x: 0, y: 5)
                VStack(alignment: .leading) {
                    Text("EVENT NAME")
                        .fontWeight(.bold)
                    TextField("Enter event name", text: $selectedTask.title)
                        .padding(10)
                        .background(Color(red: 242/255, green: 242/255, blue: 247/255))
                        .cornerRadius(15)
                }
                .padding(.horizontal, 10)
                .padding(.top, 10)
                VStack(alignment: .leading) {
                    Text("EVENT DETAIL")
                        .fontWeight(.bold)
                    TextField("Enter event description", text: Binding(get: {selectedTask.description ?? ""}, set: {selectedTask.description = $0.isEmpty ? nil : $0}), axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                        .padding(10)
                        .background(Color(red: 242/255, green: 242/255, blue: 247/255))
                        .cornerRadius(15)
                }
                .padding(10)
                HStack {
                    Text("STARTS AT")
                        .fontWeight(.bold)
                    Spacer()
                    DatePicker("Selected Time", selection: $selectedTask.startTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                .padding(.horizontal, 10)
                .padding(.top, 10)
                HStack {
                    Text("ENDS AT")
                        .fontWeight(.bold)
                    Spacer()
                    DatePicker("Selected Time", selection: $selectedTask.endTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                .padding(.horizontal, 10)
                .padding(.top, 10)
                HStack {
                    VStack(alignment: .leading) {
                        Text("COMPLEXITY")
                            .fontWeight(.bold)
                        Picker("Choose complexity", selection: $selectedTask.complexity) {
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
                        Picker("Choose complexity", selection: $selectedTask.priority) {
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
                    //add task logic
                } label: {
                    Text("CONFIRM")
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
    }
}

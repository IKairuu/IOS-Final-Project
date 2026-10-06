//
//  AddTaskView.swift
//  Project-Stella
//
//  Created by Mac-LAB on 10/6/26.
//

import SwiftUI

struct AddTaskView: View {
    @State private var selectedDate = Date()
    @State private var taskName: String = ""
    @State private var taskDescription: String = ""
    @State private var selectedStartTime = Date.now
    @State private var selectedEndTime = Date.now
    @State private var selectedPriority: Priority = .low
    @State private var selectedComplexity: Complexity = .easy
    var body: some View {
        ScrollView {
            VStack {
                DatePicker(
                    "Select Date",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .background(Design().secondaryColor)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.4), radius: 5, x: 0, y: 5)
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
                    Text("STARTS AT")
                        .fontWeight(.bold)
                    Spacer()
                    DatePicker("Selected Time", selection: $selectedStartTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                .padding(.horizontal, 10)
                .padding(.top, 10)
                HStack {
                    Text("ENDS AT")
                        .fontWeight(.bold)
                    Spacer()
                    DatePicker("Selected Time", selection: $selectedEndTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                .padding(.horizontal, 10)
                .padding(.top, 10)
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
                        Picker("Choose complexity", selection: $selectedPriority) {
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

#Preview {
    AddTaskView()
}

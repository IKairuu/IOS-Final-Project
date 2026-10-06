//
//  TaskView.swift
//  Project-Stella
//
//  Created by Mac-LAB on 10/6/26.
//

import SwiftUI

struct TaskView: View {
    @Binding var selected: Int
    @State private var events = Filter().filterEvent()
    @State private var tasks = Filter().filterTask()
    var body: some View {
        VStack {
            HStack{
                Button {
                    selected = 0
                } label: {
                    Text("Event")
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(selected == 0 ? Design().mainTheme : Color.white)
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.4), radius: 5, x: 0, y: 5)
                }
                Button {
                    selected = 1
                } label: {
                    Text("Task")
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(selected == 1 ? Design().mainTheme : Color.white)
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.4), radius: 5, x: 0, y: 5)
                }
            }
            .padding(10)
            if selected == 0 {
                if $events.isEmpty {
                    Spacer()
                    Text("There are no Events")
                    Spacer()
                }
                else {
                    List {
                        ForEach(events) { item in
                            EventSectionTab(title: item.title, description: item.description, startTime: item.startTime.formatted(.dateTime.hour(.defaultDigits(amPM: .abbreviated)).minute(.twoDigits)), endTime: item.endTime.formatted(.dateTime.hour(.defaultDigits(amPM: .abbreviated)).minute(.twoDigits)))
                        }
                        .onDelete { index in
                            events.remove(atOffsets: index)
                        }
                    }
                    .contentMargins(.top, 0,for: .scrollContent)
                }
                
            }
            else if selected == 1 {
                if $tasks.isEmpty {
                    Spacer()
                    Text("There are no Tasks")
                    Spacer()
                }
                else {
                    List {
                        ForEach(tasks) { item in
                            TaskSectionTab(title: item.title, description: item.description, startTime: item.startTime.formatted(.dateTime.hour(.defaultDigits(amPM: .abbreviated)).minute(.twoDigits)), endTime: item.endTime.formatted(.dateTime.hour(.defaultDigits(amPM: .abbreviated)).minute(.twoDigits)))
                        }
                        .onDelete { index in
                            tasks.remove(atOffsets: index)
                        }
                    }
                    .contentMargins(.top, 0,for: .scrollContent)
                }
                
            }
        }
        .padding(.bottom, 10)
        .frame(maxWidth: .infinity)
        .frame(height: 300)
        .background(Design().secondaryColor)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.4), radius: 5, x: 0, y: 5)
    }
}

struct SectionTab: View {
    let title: String
    let description: String?
    let type: String
    let startTime: String
    let endTime: String
    var body: some View {
        VStack(alignment: .leading) {
                Text(title)
                .fontWeight(.bold)
                Text("Time: \(startTime)-\(endTime)")
                .padding(.bottom, 5)
                Text("Description:")
                Text(description ?? "There is no description")
                .foregroundColor(Color.gray)
            
        }
    }
}

struct EventSectionTab: View {
    let title: String
    let description: String?
    let startTime: String
    let endTime: String
    var body: some View {
        VStack(alignment: .leading) {
                Text(title)
                .fontWeight(.bold)
                Text("Time: \(startTime)-\(endTime)")
                .padding(.bottom, 5)
                Text("Description:")
                Text(description ?? "There is no description")
                .foregroundColor(Color.gray)
            
        }
    }
}

struct TaskSectionTab: View {
    let title: String
    let description: String?
    let startTime: String
    let endTime: String
    var body: some View {
        VStack(alignment: .leading) {
                Text(title)
                .fontWeight(.bold)
                Text("Time: \(startTime)-\(endTime)")
                .padding(.bottom, 5)
                Text("Description:")
                Text(description ?? "There is no description")
                .foregroundColor(Color.gray)
            
        }
    }
}

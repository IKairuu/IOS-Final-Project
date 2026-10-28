//
//  TaskView.swift
//  Project-Stella
//
//  Created by Mac-LAB on 10/6/26.
//

import SwiftUI

struct TaskView: View {
    @Binding var selected: Int
    var date: Date = Date()
    @State private var events: [EventModel] = []
    @State private var tasks: [TaskModel] = []
    @State private var all: [ScheduleItem] = []
    var body: some View {
            VStack {
                HStack{
                    tabButton("Event", tag: 0)
                    tabButton("Task", tag: 1)
                    tabButton("All", tag: 2)
                }
                .padding(10)
                if selected == 0 {
                    if events.isEmpty {
                        Spacer()
                        Text("There are no Events")
                        Spacer()
                    }
                    else {
                        List {
                            ForEach(events) { item in
                                eventRow(item)
                            }
                            .onDelete { index in
                                deleteEvents(index.map { events[$0].id })
                            }
                        }
                        .contentMargins(.top, 0,for: .scrollContent)
                    }
                }
                else if selected == 1 {
                    if tasks.isEmpty {
                        Spacer()
                        Text("There are no Tasks")
                        Spacer()
                    }
                    else {
                        List {
                            ForEach(tasks) { item in
                                taskRow(item)
                            }
                            .onDelete { index in
                                deleteTasks(index.map { tasks[$0].id })
                            }
                        }
                        .contentMargins(.top, 0,for: .scrollContent)
                    }
                }
                else {
                    if all.isEmpty {
                        Spacer()
                        Text("There are no Events or Tasks")
                        Spacer()
                    }
                    else {
                        List {
                            ForEach(all) { item in
                                switch item {
                                case .event(let event): eventRow(event)
                                case .task(let task): taskRow(task)
                                }
                            }
                            .onDelete { index in
                                let removed = index.map { all[$0] }
                                deleteEvents(removed.compactMap { if case .event(let event) = $0 { return event.id } else { return nil } })
                                deleteTasks(removed.compactMap { if case .task(let task) = $0 { return task.id } else { return nil } })
                            }
                        }
                        .contentMargins(.top, 0,for: .scrollContent)
                    }
                }
            }
            .padding(.bottom, 10)
            .onAppear(perform: reload)
            .onChange(of: date) { reload() }
            .frame(maxWidth: .infinity)
            .frame(height: 300)
            .background(Design().secondaryColor)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.4), radius: 5, x: 0, y: 5)
        
    }

    private func tabButton(_ title: String, tag: Int) -> some View {
        Button {
            selected = tag
        } label: {
            Text(title)
                .foregroundColor(.black)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(selected == tag ? Design().mainTheme : Color.white)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.4), radius: 5, x: 0, y: 5)
        }
    }

    private func eventRow(_ item: EventModel) -> some View {
        NavigationLink{
            EventManagementView(event: item)
        } label:  {
            EventSectionTab(title: item.title, description: item.description, startTime: timeText(item.startTime), endTime: timeText(item.endTime))
        }
    }

    private func taskRow(_ item: TaskModel) -> some View {
        NavigationLink{
            TaskManagementView(task: item)
        } label:  {
            TaskSectionTab(title: item.title, description: item.description, startTime: timeText(item.startTime), endTime: timeText(item.endTime))
        }
    }

    private func timeText(_ time: Date) -> String {
        time.formatted(.dateTime.hour(.defaultDigits(amPM: .abbreviated)).minute(.twoDigits))
    }

    private func reload() {
        events = Filter().filterEvent(on: date)
        tasks = Filter().filterTask(on: date)
        all = Filter().filterAll(on: date)
    }

    private func deleteEvents(_ ids: [String]) {
        guard !ids.isEmpty else { return }
        testEvents.removeAll { ids.contains($0.id) }
        reload()
    }

    private func deleteTasks(_ ids: [String]) {
        guard !ids.isEmpty else { return }
        testTask.removeAll { ids.contains($0.id) }
        reload()
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

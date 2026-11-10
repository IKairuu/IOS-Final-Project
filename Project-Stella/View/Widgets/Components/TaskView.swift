import SwiftUI

struct TaskView: View {
    private static let dateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd-MM-yyyy h:mm a"
        return formatter
    }()
    @Binding var selected: Int
    var date: Date = Date()
    @Environment(AppState.self) private var appState
    @State private var errorMessage: String?
    @State private var isDeleting: Bool = false
    @State private var deletedMessage: String?
    @State private var events: [EventModel] = []
    @State private var tasks: [TaskModel] = []
    @State private var all: [ScheduleItem] = []
    var body: some View {
            VStack {
                HStack(spacing: 10) {
                    tabButton("Event", tag: 0)
                    tabButton("Task", tag: 1)
                    tabButton("All", tag: 2)
                }
                .padding(.horizontal, 14)
                .padding(.top, 14)
                .padding(.bottom, 6)
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
                                delete(eventIds: index.map { events[$0].id })
                            }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                        .contentMargins(.top, 4, for: .scrollContent)
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
                                delete(taskIds: index.map { tasks[$0].id })
                            }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                        .contentMargins(.top, 4, for: .scrollContent)
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
                                delete(eventIds: removed.compactMap { if case .event(let event) = $0 { return event.id } else { return nil } },
                                       taskIds: removed.compactMap { if case .task(let task) = $0 { return task.id } else { return nil } })
                            }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                        .contentMargins(.top, 4, for: .scrollContent)
                    }
                }
            }
            .padding(.bottom, 10)
            .onAppear(perform: reload)
            .onChange(of: date) { reload() }
            .alert("Deleted", isPresented: Binding(get: { deletedMessage != nil }, set: { if !$0 { deletedMessage = nil } })) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(deletedMessage ?? "")
            }
            .alert("Can't delete", isPresented: Binding(get: { errorMessage != nil }, set: { if !$0 { errorMessage = nil } })) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage ?? "")
            }
            .frame(maxWidth: .infinity)
            .frame(height: 300)
            .background(Design().secondaryColor)
            .overlay {
                if isDeleting {
                    SpinnerOverlay()
                }
            }
            .allowsHitTesting(!isDeleting)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.4), radius: 5, x: 0, y: 5)
        
    }

    private func tabButton(_ title: String, tag: Int) -> some View {
        Button {
            selected = tag
        } label: {
            Text(title)
                .foregroundColor(.white)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(selected == tag ? Design().mainTheme : Design().cardColor)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.4), radius: 5, x: 0, y: 5)
        }
    }

    private func eventRow(_ item: EventModel) -> some View {
        ZStack {
            EventSectionTab(title: item.title, description: item.description, startTime: timeText(item.startTime), endTime: timeText(item.endTime))
            NavigationLink {
                EventManagementView(event: item)
            } label: {
                EmptyView()
            }
            .opacity(0)
        }
        .scheduleRow()
    }

    private func taskRow(_ item: TaskModel) -> some View {
        ZStack {
            TaskSectionTab(title: item.title, description: item.description, startTime: timeText(item.startTime), endTime: timeText(item.endTime))
            NavigationLink {
                TaskManagementView(task: item)
            } label: {
                EmptyView()
            }
            .opacity(0)
        }
        .scheduleRow()
    }

    private func timeText(_ time: Date) -> String {
        TaskView.dateTimeFormatter.string(from: time)
    }

    private func reload() {
        events = Filter().filterEvent(on: date)
        tasks = Filter().filterTask(on: date)
        all = Filter().filterAll(on: date)
    }

    private func delete(eventIds: [String] = [], taskIds: [String] = []) {
        guard !eventIds.isEmpty || !taskIds.isEmpty else { return }
        let token = appState.token
        isDeleting = true
        Task {
            let taskError = await TaskController().deleteTasks(token: token, ids: taskIds)
            let eventError = await EventController().deleteEvents(token: token, ids: eventIds)
            reload()
            isDeleting = false
            if let error = taskError ?? eventError {
                errorMessage = error
            } else {
                deletedMessage = deletedText(eventCount: eventIds.count, taskCount: taskIds.count)
            }
        }
        events.removeAll { eventIds.contains($0.id) }
        tasks.removeAll { taskIds.contains($0.id) }
        all = Filter().filterAll(on: date).filter { item in
            switch item {
            case .event(let event): return !eventIds.contains(event.id)
            case .task(let task): return !taskIds.contains(task.id)
            }
        }
    }

    private func deletedText(eventCount: Int, taskCount: Int) -> String {
        if eventCount > 0 && taskCount > 0 {
            return "The selected events and tasks were deleted."
        }
        if eventCount > 0 {
            return eventCount == 1 ? "The event was deleted." : "\(eventCount) events were deleted."
        }
        return taskCount == 1 ? "The task was deleted." : "\(taskCount) tasks were deleted."
    }
}

struct SectionTab: View {
    let title: String
    let description: String?
    let type: String
    let startTime: String
    let endTime: String
    var body: some View {
        ScheduleCard(title: title, description: description, startTime: startTime, endTime: endTime)
    }
}

struct EventSectionTab: View {
    let title: String
    let description: String?
    let startTime: String
    let endTime: String
    var body: some View {
        ScheduleCard(title: title, description: description, startTime: startTime, endTime: endTime)
    }
}

struct TaskSectionTab: View {
    let title: String
    let description: String?
    let startTime: String
    let endTime: String
    var body: some View {
        ScheduleCard(title: title, description: description, startTime: startTime, endTime: endTime)
    }
}

struct ScheduleCard: View {
    let title: String
    let description: String?
    let startTime: String
    let endTime: String
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            VStack(alignment: .leading, spacing: 4) {
                Label("Start: \(startTime)", systemImage: "calendar")
                Label("End: \(endTime)", systemImage: "clock")
            }
            .font(.subheadline)
            .foregroundColor(.white.opacity(0.85))
            VStack(alignment: .leading, spacing: 2) {
                Text("Description:")
                    .font(.subheadline)
                    .foregroundColor(.white)
                Text(description ?? "There is no description")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Design().cardColor)
        .cornerRadius(12)
    }
}

extension View {
    func scheduleRow() -> some View {
        self
            .listRowInsets(EdgeInsets(top: 6, leading: 14, bottom: 6, trailing: 14))
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
    }
}

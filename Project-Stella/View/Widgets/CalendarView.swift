//
//  CalendarView.swift
//  Project-Stella
//
//  Created by Mac-LAB on 9/10/26.
//

import SwiftUI

struct CalendarView: View {
    @State private var selected: Int = 0
    @State private var selectedDate = Date()
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                DatePicker(
                    "Select Date",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .background(Design().secondaryColor)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.4), radius: 5, x: 0, y: 5)
                TaskView(selected: $selected)
                HStack {
                    NavigationLink {
                        AddTaskView()
                    } label: {
                        Text("ADD TASK")
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Design().mainTheme)
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.4), radius: 5, x: 0, y: 5)
                    }
                    NavigationLink {
                        AddEventView()
                    } label: {
                        Text("ADD EVENT")
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Design().mainTheme)
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.4), radius: 5, x: 0, y: 5)
                    }
                }
            }
            .padding(20)
        }
        
        
    }
}

#Preview {
    CalendarView()
}

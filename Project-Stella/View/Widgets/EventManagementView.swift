//
//  EventManagementView.swift
//  Project-Stella
//
//  Created by Mac-LAB on 9/10/26.
//

import SwiftUI

struct EventManagementView: View {
    @Binding var selectedEvent: EventModel
    var body: some View {
        ScrollView {
            VStack {
                DatePicker(
                    "Select Date",
                    selection: $selectedEvent.startTime,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .background(Design().secondaryColor)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.4), radius: 5, x: 0, y: 5)
                VStack(alignment: .leading) {
                    Text("EVENT NAME")
                        .fontWeight(.bold)
                    TextField("Enter event name", text: $selectedEvent.title)
                        .padding(10)
                        .background(Color(red: 242/255, green: 242/255, blue: 247/255))
                        .cornerRadius(15)
                }
                .padding(.horizontal, 10)
                .padding(.top, 10)
                VStack(alignment: .leading) {
                    Text("EVENT DETAIL")
                        .fontWeight(.bold)
                    TextField("Enter event description", text: Binding(get: {selectedEvent.description ?? ""}, set: {selectedEvent.description = $0.isEmpty ? nil : $0}), axis: .vertical)
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
                    DatePicker("Selected Time", selection: $selectedEvent.startTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                .padding(.horizontal, 10)
                .padding(.top, 10)
                HStack {
                    Text("ENDS AT")
                        .fontWeight(.bold)
                    Spacer()
                    DatePicker("Selected Time", selection: $selectedEvent.endTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
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

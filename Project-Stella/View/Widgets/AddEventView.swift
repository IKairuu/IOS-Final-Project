//
//  AddEventView.swift
//  Project-Stella
//
//  Created by Mac-LAB on 10/8/26.
//

import SwiftUI

struct AddEventView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppState.self) private var appState
    @State private var errorMessage: String?
    @State private var showSaved: Bool = false
    @State private var selectedStartDate = Date()
    @State private var selectedEndDate = Date().addingTimeInterval(3600)
    @State private var eventName: String = ""
    @State private var eventDetail: String = ""
    var body: some View {
        ScrollView {
            VStack {
                ScheduleSection(startDate: $selectedStartDate, endDate: $selectedEndDate)
                    .padding(.horizontal, 10)
                VStack(alignment: .leading) {
                    Text("EVENT NAME")
                        .fontWeight(.bold)
                    TextField("Enter event name", text: $eventName)
                        .padding(10)
                        .background(Design().secondaryColor)
                        .cornerRadius(15)
                }
                .padding(.horizontal, 10)
                .padding(.top, 10)
                VStack(alignment: .leading) {
                    Text("EVENT DETAIL")
                        .fontWeight(.bold)
                    TextField("Enter event description", text: $eventDetail, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                        .padding(10)
                        .background(Design().secondaryColor)
                        .cornerRadius(15)
                }
                .padding(10)
                Button {
                    Task {
                        errorMessage = await EventController().addEvent(token: appState.token, eventName: eventName, eventDetail: eventDetail, startTime: selectedStartDate, endTime: selectedEndDate)
                        if errorMessage == nil {
                            showSaved = true
                        }
                    }
                } label: {
                    Text("CONFIRM")
                        .foregroundColor(.white)
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
        .alert("Event added", isPresented: $showSaved) {
            Button("OK") { dismiss() }
        } message: {
            Text("\(eventName) was added to your events.")
        }
        .alert("Can't add event", isPresented: Binding(get: { errorMessage != nil }, set: { if !$0 { errorMessage = nil } })) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage ?? "")
        }
    }
}

#Preview {
    AddEventView()
        .environment(AppState())
}

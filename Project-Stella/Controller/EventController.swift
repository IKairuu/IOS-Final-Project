//
//  EventController.swift
//  Project-Stella
//
//  Created by Mac-LAB on 10/14/26.
//
import SwiftUI
internal import Combine

final class EventController: ObservableObject {
    // Placeholder: saves to the local test data until the backend is wired in.
    // Returns an error message, or nil when the event was added.
    func addEvent(eventName: String, eventDetail: String, startTime: Date, endTime: Date) -> String? {
        let name = eventName.trimmingCharacters(in: .whitespacesAndNewlines)
        if name.isEmpty {
            return "Please enter an event name."
        }
        if endTime <= startTime {
            return "The end time must be after the start time."
        }
        let detail = eventDetail.trimmingCharacters(in: .whitespacesAndNewlines)
        let newEvent = EventModel(id: UUID().uuidString, title: name, description: detail.isEmpty ? nil : detail, startTime: startTime, endTime: endTime)
        testEvents.append(newEvent)
        return nil
    }
}

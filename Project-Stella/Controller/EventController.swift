//
//  EventController.swift
//  Project-Stella
//
//  Created by Mac-LAB on 10/14/26.
//
import SwiftUI
internal import Combine

final class EventController: ObservableObject {
    func addEvent(token: String?, eventName: String, eventDetail: String, startTime: Date, endTime: Date) async -> String? {
        let name = eventName.trimmingCharacters(in: .whitespacesAndNewlines)
        if name.isEmpty {
            return "Please enter an event name."
        }
        if endTime <= startTime {
            return "The end time must be after the start time."
        }
        guard let token else {
            return "You are not logged in."
        }
        let detail = eventDetail.trimmingCharacters(in: .whitespacesAndNewlines)
        let body = EventDatasource.EventRequest(id: nil,
                                                title: name,
                                                description: detail.isEmpty ? nil : detail,
                                                start_time: TaskDatasource.isoString(startTime),
                                                end_time: TaskDatasource.isoString(endTime))
        do {
            try await EventDatasource().createEvent(token: token, body: body)
            testEvents = try await EventDatasource().getEvents(token: token)
            return nil
        } catch {
            return "Could not save the event. Please try again."
        }
    }
    
    func updateEvent(token: String?, eventId: String, eventName: String, eventDetail: String, startTime: Date, endTime: Date) async -> String? {
        let name = eventName.trimmingCharacters(in: .whitespacesAndNewlines)
        if name.isEmpty {
            return "Please enter an event name."
        }
        if endTime <= startTime {
            return "The end time must be after the start time."
        }
        guard testEvents.contains(where: { $0.id == eventId }) else {
            return "This event no longer exists."
        }
        guard let token else {
            return "You are not logged in."
        }
        let detail = eventDetail.trimmingCharacters(in: .whitespacesAndNewlines)
        let body = EventDatasource.EventRequest(id: eventId,
                                                title: name,
                                                description: detail.isEmpty ? nil : detail,
                                                start_time: TaskDatasource.isoString(startTime),
                                                end_time: TaskDatasource.isoString(endTime))
        do {
            try await EventDatasource().editEvent(token: token, body: body)
            testEvents = try await EventDatasource().getEvents(token: token)
            return nil
        } catch {
            return "Could not update the event. Please try again."
        }
    }
}

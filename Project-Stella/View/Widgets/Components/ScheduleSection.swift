//
//  ScheduleSection.swift
//  Project-Stella
//
//  Created by Mac-LAB on 10/14/26.
//

import SwiftUI

enum ScheduleField {
    case start, end
}

struct ScheduleSection: View {
    @Binding var startDate: Date
    @Binding var endDate: Date
    @State private var openCalendar: ScheduleField?
    
    private var durationText: String? {
        guard endDate > startDate else { return nil }
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute]
        formatter.unitsStyle = .short
        return formatter.string(from: startDate, to: endDate)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("SCHEDULE")
                .fontWeight(.bold)
            VStack(spacing: 0) {
                ScheduleRow(label: "Starts", isEnd: false, date: $startDate, isOpen: openCalendar == .start) {
                    toggle(.start)
                }
                if openCalendar == .start {
                    DatePicker("Start date", selection: $startDate, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .tint(Design().mainTheme)
                        .padding(.horizontal, 10)
                }
                Divider()
                    .padding(.leading, 12)
                ScheduleRow(label: "Ends", isEnd: true, date: $endDate, isOpen: openCalendar == .end) {
                    toggle(.end)
                }
                if openCalendar == .end {
                    DatePicker("End date", selection: $endDate, in: Calendar.current.startOfDay(for: startDate)..., displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .tint(Design().mainTheme)
                        .padding(.horizontal, 10)
                }
            }
            .background(Design().secondaryColor)
            .cornerRadius(15)
            
            if let durationText {
                Text("Lasts \(durationText)")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.leading, 4)
            }
            else {
                Text("End must be after the start")
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.leading, 4)
            }
        }
        .onChange(of: startDate) { oldValue, newValue in
            if endDate <= newValue {
                let length = max(endDate.timeIntervalSince(oldValue), 3600)
                endDate = newValue.addingTimeInterval(length)
            }
        }
    }
    
    private func toggle(_ field: ScheduleField) {
        withAnimation(.easeInOut(duration: 0.2)) {
            openCalendar = openCalendar == field ? nil : field
        }
    }
}

struct ScheduleRow: View {
    let label: String
    let isEnd: Bool
    @Binding var date: Date
    let isOpen: Bool
    let onDateTap: () -> Void
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(isEnd ? Design().cardColor : Design().mainTheme)
                .overlay(Circle().stroke(Design().mainTheme, lineWidth: 2))
                .frame(width: 8, height: 8)
            Text(label)
            Spacer()
            Button(action: onDateTap) {
                Text(date.formatted(.dateTime.month(.abbreviated).day().year()))
                    .foregroundColor(.white)
                    .fontWeight(isOpen ? .semibold : .regular)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(isOpen ? Design().mainTheme.opacity(0.3) : Design().cardColor)
                    .cornerRadius(8)
            }
            DatePicker(label, selection: $date, displayedComponents: .hourAndMinute)
                .labelsHidden()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }
}

#Preview {
    @Previewable @State var start = Date()
    @Previewable @State var end = Date().addingTimeInterval(3600)
    ScheduleSection(startDate: $start, endDate: $end)
        .padding(20)
}

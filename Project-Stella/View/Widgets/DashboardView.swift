//
//  DashboardView.swift
//  Project-Stella
//
//  Created by Mac-LAB on 9/10/26.
//

import SwiftUI
import Charts

enum ChartSelection: String {
    case priority, complexity
}

struct DashboardView: View {
    @State private var statSelection: ChartSelection = .priority
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                TopSection()
                DashboardCompanionPreview()
                Statistics(statSelection: $statSelection)
                
                
            }
            .padding(20)
        }
    }
}

struct TopSection: View {
    var body: some View {
        HStack {
            HStack(spacing: 10) {
                Text("\(testTask.count)")
                    .font(.custom("Roboto-Black", size: 50))
                    .fontWeight(.black)
                    .frame(width: 80, height: 100)
                    .background(Color.white)
                    .cornerRadius(15)
                    
                VStack(spacing: 5) {
                    Text("Tasks")
                        .fontWeight(.black)
                    Text("Today")
                        .fontWeight(.black)
                }
            }
            .padding(.vertical, 10)
            .padding(.leading, 10)
            Spacer()
            HStack(spacing: 10) {
                Text("\(testTask.count)")
                    .font(.custom("Roboto-Black", size: 50))
                    .fontWeight(.black)
                    .frame(width: 80, height: 100)
                    .background(Color.white)
                    .cornerRadius(15)
                    
                VStack(spacing: 5) {
                    Text("Events")
                        .fontWeight(.black)
                    Text("Today")
                        .fontWeight(.black)
                }
            }
            .padding(.vertical, 10)
            .padding(.trailing, 10)
            
        }
        .background(Design().mainTheme)
        .cornerRadius(15)
    }
}

struct DashboardCompanionPreview: View {
    var body: some View {
            VStack {
                VStack {
                    HStack{
                        Image("chat logo")
                        Text("Stella AI")
                            .fontWeight(.bold)
                        Spacer()
                    }
                    ScrollView {
                        Text("""
                             You have 3 tasks and 5 scheduled events today. Your workload is moderate, with approximately 4 hours of available time.
                             
                             You have a high-priority Mathematics Quiz tomorrow. I recommend using 2 hours this afternoon for review while you have enough free time.
                             Recommendation: Focus on the Mathematics Quiz first, then work on your lower-priority tasks.
                             """)
                    }
                }
                .padding(10)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 240)
            .background(Design().secondaryColor)
            .cornerRadius(15)
        
    }
}

struct Statistics: View {
    @Binding var statSelection: ChartSelection
    var workloadData: [String: [String: Any]] = StatisticsController().weeklyWorkload()
    var priorityData: [String: Int] {
        (statSelection == ChartSelection.priority ? StatisticsController().priorityStatistics() : StatisticsController().complexityStatistics())
    }
    var body: some View {
        VStack {
            HStack {
                Text("STELLA Statistics")
                    .fontWeight(.bold)
                Spacer()
                Picker("", selection: $statSelection){
                    Text("Priority").tag(ChartSelection.priority)
                    Text("Complexity").tag(ChartSelection.complexity)
                }
                .pickerStyle(.segmented)
                
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            if (statSelection == .priority){
                Chart {
                    BarMark(x: .value("Priority", "Low"), y: .value("Tasks", priorityData["Low"]!))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .foregroundStyle(Color.green)
                    BarMark(x: .value("Priority", "Medium"), y: .value("Tasks", priorityData["Medium"]!))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .foregroundStyle(Color.orange)
                    BarMark(x: .value("Priority", "High"), y: .value("Tasks", priorityData["High"]!))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .foregroundStyle(Color.red)
                }
                .padding(10)
                .frame(maxWidth: .infinity, maxHeight: 200)
                .background(Color.white)
                .cornerRadius(15)
                .padding(.horizontal, 10)
                
                
            }
            else{
                Chart {
                    BarMark(x: .value("Complexity", "Easy"), y: .value("Tasks", priorityData["Easy"]!))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .foregroundStyle(Color.green)
                    BarMark(x: .value("Complexity", "Medium"), y: .value("Tasks", priorityData["Medium"]!))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .foregroundStyle(Color.orange)
                    BarMark(x: .value("Complexity", "Hard"), y: .value("Tasks", priorityData["Hard"]!))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .foregroundStyle(Color.red)
                }
                .padding(10)
                .frame(maxWidth: .infinity, maxHeight: 200)
                .background(Color.white)
                .cornerRadius(15)
                .padding(.horizontal, 10)

            }
            HStack{
                Text("Weekly Vacancies and Workload")
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
            
            Chart {
                ForEach(Array(workloadData), id: \.key){ key, value in
                    if let day = value["Day"] as? String, let workload = value["Workload"] as? Double {
                        BarMark(x: .value("Day", day), y: .value("Hours", workload))
                            .foregroundStyle(Design().statWorkColor)
                    }
                    
                    if let day = value["Day"] as? String, let vacancy = value["Vacancy"] as? Double {
                        BarMark(x: .value("Day", day), y: .value("Hours", vacancy))
                            .foregroundStyle(Color(Design().statVacColor))
                    }
                }
            }
            .chartForegroundStyleScale(["Workload": Design().statWorkColor, "Vacancy": Design().statVacColor])
            .padding(10)
            .frame(maxWidth: .infinity, maxHeight: 200)
            .background(Color.white)
            .cornerRadius(15)
            .padding(.horizontal, 10)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 500)
        .background(Design().secondaryColor)
        .cornerRadius(15)
    }
}
#Preview {
    DashboardView()
}

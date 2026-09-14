//
//  HomePage.swift
//  Project-Stella
//
//  Created by Mac-LAB on 9/8/26.
//

import SwiftUI

struct HomePage: View {
    @State private var selection: Int = 1
    var body:some View {
        NavigationStack {
            VStack {
                TabView(selection: $selection) {
                    CalendarView()
                        .tabItem {
                            NavigationLabel(label: "Calendar", icon: "calendar")
                        }
                        .tag(0)
                    DashboardView()
                        .tabItem {
                            NavigationLabel(label: "Dashboard", icon: "house")
                        }
                        .tag(1)
                    CompanionView()
                        .tabItem {
                            NavigationLabel(label: "STELLA AI", icon: "sparkles")
                        }
                        .tag(2)
                }
                .tint(Design().mainTheme)
                .onAppear(perform: {
                    UIScrollView.appearance().bounces = false
                })
                .onDisappear(perform: {
                    UIScrollView.appearance().bounces = false
                })
            }
            .navigationBarBackButtonHidden(true)
            .navigationTitle("Welcome \(testUser.username)!")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing){
                    NavigationLink {
                        AuthSelection()
                    } label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                    }
                }
            }
        }
    }
}

struct NavigationLabel: View {
    let label: String
    let icon: String
    var body: some View {
        Image(systemName: icon)
        Text(label)
    }
}


#Preview {
    HomePage()
}

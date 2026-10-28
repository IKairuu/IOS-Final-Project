//
//  RootView.swift
//  Project-Stella
//
//  Created by Mac-LAB on 10/28/26.
//

import SwiftUI

struct RootView: View {
    @Environment(AppState.self) private var appState
    var body: some View {
        Group {
            switch appState.sessionStatus {
            case .checking:
                VStack {
                    MainLogo()
                    ProgressView()
                        .padding(.top, 20)
                }
            case .signedOut:
                NavigationStack {
                    AuthSelection()
                }
            case .signedIn:
                HomePage()
            }
        }
        .id(appState.rootId)
        .task {
            if appState.sessionStatus == .checking {
                await SessionController().restoreSession(appState: appState)
            }
        }
    }
}

#Preview {
    RootView()
        .environment(AppState())
}

//
//  Project_StellaApp.swift
//  Project-Stella
//
//  Created by Mac-LAB on 9/1/26.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class AppDelegate: NSObject,UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct Project_StellaApp: App {
    @State private var appState = AppState()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                AuthSelection()
                    .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
            }
        }
        .environment(appState)
    }
}

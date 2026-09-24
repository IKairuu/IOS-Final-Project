//
//  AuthSelection.swift
//  Project-Stella
//
//  Created by Mac-LAB on 9/1/26.
//

import SwiftUI
import FirebaseAuth


struct AuthSelection: View {
    @State private var err: String = ""
    @State private var switchPage: Bool = false
    @Environment(AppState.self) private var appState
    var body: some View {
        VStack {
            MainLogo()
            VStack{
                Text("Smarter Schedules")
                    .font(.custom("Roboto-ExtraLight", size: 20))
                Text("Plan Your Events")
                    .font(.custom("Roboto-ExtraLight", size: 20))
                Text("Your STELLA Companion")
                    .font(.custom("Roboto-ExtraLight", size: 20))
            }
            .padding(30)
            SectionDivider()
            NavigationStack {
                Button {
                    Task {
                        do {
                            try await AuthenticationController().googleSignIn()
                            print(Auth.auth().currentUser!.uid)
                            let token = try await AuthenticationDatasource().registerUserGoogleAccount(googleUid: Auth.auth().currentUser!.uid, email: Auth.auth().currentUser!.email!)
                            appState.token = token
                            try await AuthenticationController().logout()
                            switchPage.toggle()
                        } catch AuthenticationError.runtimeError(let errorMessage) {
                            err = errorMessage
                            print("Error")
                        }
                    }
                } label: {
                    Text("Register")
                        .frame(maxWidth: .infinity, maxHeight: 30)
                        .fontWeight(.black)
                        .foregroundColor(Color.black)
                        .padding()
                        .background(Color(red: 255/255, green: 213/255, blue: 79/255))
                        .cornerRadius(15)
                }
            }
            .navigationDestination(isPresented: $switchPage) {
                RegistrationFormPage()
            }
            NavigationLink {
                LoginFormPage()
            } label: {
                Text("Login")
                    .frame(maxWidth: .infinity, maxHeight: 30)
                    .fontWeight(.black)
                    .foregroundColor(Color.black)
                    .padding()
                    .background(Color(red: 242/255, green: 242/255, blue: 247/255))
                    .cornerRadius(15)
            }
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .padding(40)
        
    }
}

#Preview {
    AuthSelection()
}


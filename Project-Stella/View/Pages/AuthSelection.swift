//
//  AuthSelection.swift
//  Project-Stella
//
//  Created by Mac-LAB on 9/1/26.
//

import SwiftUI

struct AuthSelection: View {
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
            NavigationLink {
                RegistrationFormPage()
            } label: {
                Text("Register")
                    .frame(maxWidth: .infinity, maxHeight: 30)
                    .fontWeight(.black)
                    .foregroundColor(Color.black)
                    .padding()
                    .background(Color(red: 255/255, green: 213/255, blue: 79/255))
                    .cornerRadius(15)
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


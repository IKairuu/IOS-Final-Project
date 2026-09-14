//
//  LoginFormPage.swift
//  Project-Stella
//
//  Created by Mac-LAB on 9/1/26.
//

import SwiftUI

struct LoginFormPage: View {
    @State private var emailInput: String = ""
    @State private var passwordInput: String = ""
    @State private var passwordVisible: Bool = false
    @State private var keepMeSignedIn: Bool = false
    var body: some View {
        VStack {
            MainLogo().padding(.bottom, 30)
            SectionDivider()
            VStack(alignment: .leading) {
                Text("Email Address/Username")
                    .font(.custom("Roboto-Regular", size: 14))
                TextField("Enter Email or Username", text: $emailInput)
                    .padding(10)
                    .background(Color(red: 242/255, green: 242/255, blue: 247/255))
                    .cornerRadius(15)
            }
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(.never)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 5)
            VStack(alignment: .leading) {
                Text("Password")
                    .font(.custom("Roboto-Regular", size: 14))
                HStack {
                    if (passwordVisible){
                        TextField("Enter Password", text: $passwordInput)
                            .padding(10)
                            .background(Color(red: 242/255, green: 242/255, blue: 247/255))
                            .cornerRadius(15)
                    }
                    else{
                        SecureField("Enter Password", text: $passwordInput)
                            .padding(10)
                            .background(Color(red: 242/255, green: 242/255, blue: 247/255))
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                            .cornerRadius(15)
                    }
                    Button(action:{
                        togglePassword()
                    }){
                        Image(systemName: passwordVisible ? "eye.fill" : "eye.slash.fill")
                            .foregroundColor(Color.black)
                    }

                }
            }
            .padding(.vertical, 5)
            NavigationLink {
                HomePage()
            } label: {
                Text("CONFIRM")
                    .frame(maxWidth: .infinity, maxHeight: 10)
                    .fontWeight(.black)
                    .foregroundColor(Color.black)
                    .padding()
                    .background(Design().mainTheme)
                    .cornerRadius(15)
            }
                Text("OR")
                .fontWeight(.black)
                .foregroundColor(Color.black)
                .padding(.vertical, 10)
            NavigationLink {
                HomePage()
            } label: {
                HStack{
                    Image("google 1")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(5)
                        .background(Color.white)
                        .cornerRadius(15)
                    Spacer()
                    Text("Continue with Google")
                    Spacer()
                }
            }
                .frame(maxWidth: .infinity, maxHeight: 10)
                .fontWeight(.black)
                .foregroundColor(Color.black)
                .padding()
                .background(Design().mainTheme)
                .cornerRadius(15)
            SectionDivider()
            Toggle("Remember me", isOn: $keepMeSignedIn)
                .toggleStyle(.switch)
            NavigationLink {
                AuthSelection()
            } label: {
                Text("BACK")
                    .frame(maxWidth: .infinity, maxHeight: 10)
                    .fontWeight(.black)
                    .foregroundColor(Color.black)
                    .padding()
                    .background(Design().backButtonColor)
                    .cornerRadius(15)
            }
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .padding(40)
        
    } 
    func togglePassword(){
        withAnimation(.easeInOut(duration: 0.3)) {
            passwordVisible.toggle()
        }
    }
}


#Preview {
    LoginFormPage()
}

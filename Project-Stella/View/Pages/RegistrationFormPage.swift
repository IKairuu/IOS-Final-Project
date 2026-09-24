//
//  RegistrationFormPage.swift
//  Project-Stella
//
//  Created by Mac-LAB on 9/1/26.
//

import SwiftUI

struct RegistrationFormPage: View {
    @State private var email: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var occupation: String = ""
    @State private var passwordVisible: Bool = false
    var body: some View {
        VStack {
            MainLogo()
            SectionDivider()
            RegistrationInputField(userInput: $email, label: "Email Address")
            RegistrationInputField(userInput: $username, label: "Username")
            
            VStack(alignment: .leading) {
                Text("Password")
                    .font(.custom("Roboto-Regular", size: 14))
                HStack {
                    if (passwordVisible){
                        TextField("Enter Password", text: $password)
                            .padding(10)
                            .background(Color(red: 242/255, green: 242/255, blue: 247/255))
                            .cornerRadius(15)
                    }
                    else{
                        SecureField("Enter Password", text: $password)
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
            .frame(maxWidth: .infinity)
            .padding(.vertical, 5)
            
            RegistrationInputField(userInput: $occupation, label: "Occupation")
                .padding(.bottom, 20)
            SectionDivider()
            NavigationStack
            NavigationLink {
                HomePage()
            } label: {
                Text("CONFIRM")
                    .frame(maxWidth: .infinity, maxHeight: 10)
                    .fontWeight(.black)
                    .foregroundColor(Color.black)
                    .padding()
                    .background(Color(red: 255/255, green: 213/255, blue: 79/255))
                    .cornerRadius(15)
            }
            NavigationLink {
                AuthSelection()
            } label: {
                Text("BACK")
                    .frame(maxWidth: .infinity, maxHeight: 10)
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
    
    func togglePassword(){
        withAnimation(.easeInOut(duration: 0.3)) {
            passwordVisible.toggle()
        }
    }
            
}

struct RegistrationInputField: View{
    @Binding var userInput: String
    var label: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.custom("Roboto-Regular", size: 14))
            TextField("Enter \(label)", text: $userInput)
                .padding(10)
                .background(Color(red: 242/255, green: 242/255, blue: 247/255))
                .cornerRadius(15)
        }
        .autocorrectionDisabled(true)
        .textInputAutocapitalization(.never)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 5)
    }
}

#Preview {
    RegistrationFormPage()
}


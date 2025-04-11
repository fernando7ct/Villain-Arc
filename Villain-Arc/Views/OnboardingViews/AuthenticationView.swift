//
//  AuthenticationView.swift
//  Villain-Arc
//
//  Created by Fernando Caudillo Tafoya on 4/10/25.
//

import SwiftUI

struct AuthenticationView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @FocusState private var passwordFocused: Bool
    
    private func signIn() {
        AuthManager.shared.signIn(email: email.trimmingCharacters(in: .whitespacesAndNewlines), password: password)
    }
    
    var body: some View {
        VStack(spacing: 15) {
            Spacer()
            
            Button {
                
            } label: {
                Label("Sign in with Apple", systemImage: "apple.logo")
                    .signInButtonStyle()
            }
            
            Button {
                
            } label: {
                HStack {
                    Image("google.logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 19)
                    Text("Sign in with Google")
                }
                .signInButtonStyle()
            }
            
            Text("-Or-")
                .foregroundStyle(.white)
            
            TextField("Email", text: $email)
                .emailPasswordButtonStyle()
                .submitLabel(.next)
                .onSubmit {
                    passwordFocused = true
                }
            
            SecureField("Password", text: $password)
                .emailPasswordButtonStyle()
                .focused($passwordFocused)
                .submitLabel(.done)
                .onSubmit {
                    signIn()
                }
            
            HStack {
                Spacer()
                
                Button {
                    
                } label: {
                    Text("Forgot Password?")
                        .foregroundStyle(.red)
                }
            }
            
            Spacer()
            
            Button {
                signIn()
            } label: {
                Text("Sign In")
                    .continueButtonStyle()
            }
            .disabled(email.isEmpty || password.isEmpty)
            .opacity(email.isEmpty || password.isEmpty ? 0.5 : 1)
            
            Spacer()
        }
        .padding(.horizontal, 30)
    }
}

#Preview {
    ZStack {
        Background()
        
        AuthenticationView()
    }
}

//
//  AuthenticationView.swift
//  Villain-Arc
//
//  Created by Fernando Caudillo Tafoya on 4/10/25.
//

import SwiftUI

struct AuthenticationView: View {
    @Environment(\.modelContext) private var context
    @State private var email: String = ""
    @State private var password: String = ""
    @FocusState private var passwordFocused: Bool
    @Binding var currentPage: OnboardingPage
    @State private var showWrongPasswordAlert = false
    
    var invalidPassword: Bool {
        password.count < 8
    }
    var invalidEmail: Bool {
        return !email.trimmingCharacters(in: .whitespacesAndNewlines).isValidEmail
    }
    
    private func signIn() {
        AuthManager.shared.signIn(email: email.trimmingCharacters(in: .whitespacesAndNewlines), password: password) { result in
            switch result {
            case .error:
                return
            case .newUser:
                currentPage = .profile
            case .wrongPassword:
                showWrongPasswordAlert = true
            case .existingUser:
                DataManager.shared.downloadUserData(context: context)
            }
        }
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
                .emailPasswordTextFieldStyle()
                .submitLabel(.next)
                .onSubmit {
                    passwordFocused = true
                }
            
            SecureField("Password", text: $password)
                .emailPasswordTextFieldStyle()
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
                        .fontWeight(.semibold)
                }
            }
            
            Spacer()
            
            Button {
                signIn()
            } label: {
                Text("Sign In")
                    .continueButtonStyle()
            }
            .disabled(invalidEmail || invalidPassword)
            .opacity(invalidEmail || invalidPassword ? 0.5 : 1)
            
            Spacer()
        }
        .padding(.horizontal, 30)
        .alert("Incorrect Password", isPresented: $showWrongPasswordAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("The password you entered is incorrect. Please try again.")
        }
    }
}

#Preview {
    @Previewable @State var currentPage: OnboardingPage = .authentication
    
    ZStack {
        Background()
        
        AuthenticationView(currentPage: $currentPage)
    }
}

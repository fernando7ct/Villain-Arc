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
    @State private var showPasswordResetAlert = false
    @State private var failedSignInAlert = false
    
    var invalidPassword: Bool {
        password.count < 8 || password.contains(" ")
    }
    var invalidEmail: Bool {
        return !email.trimmingCharacters(in: .whitespacesAndNewlines).isValidEmail
    }
    private func signIn(result: AuthenticationResult) {
        switch result {
        case .error:
            failedSignInAlert = true
        case .newUser:
            currentPage = .profile
        case .wrongPassword:
            showWrongPasswordAlert = true
        case .existingUser:
            DataManager.shared.downloadUserData(context: context)
        }
    }
    
    var body: some View {
        VStack(spacing: 15) {
            Spacer()
            
            Button {
                Task {
                    do {
                        try await AuthManager.shared.signInApple { result in
                            signIn(result: result)
                        }
                    } catch {
                        signIn(result: .error)
                    }
                }
            } label: {
                Label("Continue with Apple", systemImage: "apple.logo")
                    .signInButtonStyle()
            }
            
            Button {
                Task {
                    do {
                        try await AuthManager.shared.signInGoogle { result in
                            signIn(result: result)
                        }
                    } catch {
                        signIn(result: .error)
                    }
                }
            } label: {
                HStack {
                    Image("google.logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 19)
                    Text("Continue with Google")
                }
                .signInButtonStyle()
            }
            
            Text("-Or-")
                .foregroundStyle(.white)
            
            TextField("Email", text: $email)
                .emailPasswordTextFieldStyle()
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .submitLabel(.next)
                .onSubmit {
                    passwordFocused = true
                }
            
            SecureField("Password", text: $password)
                .emailPasswordTextFieldStyle()
                .focused($passwordFocused)
                .submitLabel(.done)
            
            HStack {
                Spacer()
                
                Button {
                    AuthManager.shared.resetPassword(email: email.trimmingCharacters(in: .whitespacesAndNewlines)) { error in
                        if error == nil {
                            showPasswordResetAlert = true
                        }
                    }
                } label: {
                    Text("Forgot Password?")
                        .foregroundStyle(.red)
                        .fontWeight(.semibold)
                }
                .disabled(invalidEmail)
                .opacity(invalidEmail ? 0.5 : 1)
            }
            
            Spacer()
            
            Button {
                Task {
                    AuthManager.shared.signIn(email: email.trimmingCharacters(in: .whitespacesAndNewlines), password: password) { result in
                        signIn(result: result)
                    }
                }
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
        .alert("Password Reset", isPresented: $showPasswordResetAlert) {
            Button("Ok", role: .cancel) { }
        } message: {
            Text("A password reset email has been sent to your email address.")
        }
        .alert("Failed to Sign In", isPresented: $failedSignInAlert) {
            Button("Ok", role: .cancel) { }
        } message: {
            Text("Failed to sign in. Please try again later.")
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

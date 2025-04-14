//
//  OnboardingView.swift
//  WelcomeView.swift 4/12/25.
//  Villain-Arc
//
//  Created by Fernando Caudillo Tafoya on 4/10/25.
//

import SwiftUI

struct WelcomeView: View {
    @Environment(\.modelContext) private var context
    @AppStorage("showWelcomeView") var showWelcomeView: Bool = true
    @State private var opacity: Double = 0
    @State private var failedSignInAlert = false
    
    private func handleAuthResult(_ result: AuthenticationResult) {
        switch result {
        case .error:
            failedSignInAlert = true
        case .newUser:
            showWelcomeView = false
        case .existingUser:
            DataManager.shared.downloadUserData(context: context)
        }
    }
    
    private func signInWithGoogle() {
        Task {
            do {
                try await AuthManager.shared.signInGoogle { result in
                    handleAuthResult(result)
                }
            } catch {
                handleAuthResult(.error)
            }
        }
    }
    
    private func signInWithApple() {
        Task {
            await AuthManager.shared.signInApple { result in
                handleAuthResult(result)
            }
        }
    }
    
    var body: some View {
        ZStack {
            Background()
            
            VStack {
                Text("Villain Arc")
                    .font(.system(size: 52, weight: .bold))
                    .foregroundStyle(.white)
                    .opacity(opacity)
                
                if showWelcomeView {
                    Spacer()
                    VStack(spacing: 15) {
                        GoogleSignInButton()
                        AppleSignInButton()
                    }
                    .opacity(opacity)
                    .padding(.horizontal, 30)
                    .alert("Failed to Sign In", isPresented: $failedSignInAlert) {
                        Button("Ok", role: .cancel) { }
                    } message: {
                        Text("Failed to sign in. Please try again later.")
                    }
                } else {
                    UserQuestionsView()
                        .transition(.blurReplace)
                }
            }
            .padding(.vertical, 30)
            .animation(.smooth, value: showWelcomeView)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.linear(duration: 1)) {
                        self.opacity = 1
                    }
                }
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    @ViewBuilder
    private func GoogleSignInButton() -> some View {
        Button {
            signInWithGoogle()
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
    }
    
    @ViewBuilder
    private func AppleSignInButton() -> some View {
        Button {
            signInWithApple()
        } label: {
            Label("Continue with Apple", systemImage: "apple.logo")
                .signInButtonStyle()
        }
    }
}

#Preview {
    WelcomeView()
}

//
//  OnboardingView.swift
//  Villain-Arc
//
//  Created by Fernando Caudillo Tafoya on 4/10/25.
//

import SwiftUI

enum OnboardingPage {
    case welcome, authentication, profile
}

struct OnboardingView: View {
    @State private var currentPage: OnboardingPage = .welcome
    @State private var opacity: Double = 0
    
    var body: some View {
        ZStack {
            Background()
            
            VStack {
                Text("Villain Arc")
                    .font(.system(size: 52, weight: .bold))
                    .foregroundStyle(.white)
                    .opacity(opacity)
                
                if currentPage == .welcome {
                    WelcomeView(currentPage: $currentPage)
                        .transition(.blurReplace)
                        .opacity(opacity)
                } else if currentPage == .authentication {
                    AuthenticationView(currentPage: $currentPage)
                        .transition(.blurReplace)
                } else {
                    UserQuestionsView()
                        .transition(.blurReplace)
                }
            }
            .padding(.top, 30)
            .animation(.smooth, value: currentPage)
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
}

#Preview {
    OnboardingView()
}

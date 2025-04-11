//
//  OnboardingView.swift
//  Villain-Arc
//
//  Created by Fernando Caudillo Tafoya on 4/10/25.
//

import SwiftUI

enum OnboardingPage {
    case welcome, authentication, signIn, singUp
}

struct OnboardingView: View {
    @State var currentPage: OnboardingPage = .welcome
    
    var body: some View {
        ZStack {
            Background()
            
            VStack {
                Text("Villain Arc")
                    .font(.system(size: 52, weight: .bold))
                    .foregroundStyle(.white)
                if currentPage == .welcome {
                    WelcomeView(currentPage: $currentPage)
                        .transition(.move(edge: .leading))
                } else if currentPage == .authentication {
                    AuthenticationView()
                        .transition(.move(edge: .trailing))
                }
            }
            .safeAreaPadding(.top, 30)
            .animation(.easeInOut, value: currentPage)
        }
    }
}

#Preview {
    OnboardingView()
}

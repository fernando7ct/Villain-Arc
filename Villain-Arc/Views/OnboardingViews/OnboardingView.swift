//
//  OnboardingView.swift
//  Villain-Arc
//
//  Created by Fernando Caudillo Tafoya on 4/10/25.
//

import SwiftUI

enum OnboardingPage {
    case welcome, authentication, emailPass, profile
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
                        .transition(.blurReplace)
                } else if currentPage == .authentication {
                    AuthenticationView()
                        .transition(.blurReplace)
                }
            }
            .safeAreaPadding(.top, 30)
            .animation(.smooth, value: currentPage)
        }
    }
}

#Preview {
    OnboardingView()
}

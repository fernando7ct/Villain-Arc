//
//  WelcomeView.swift
//  Villain-Arc
//
//  Created by Fernando Caudillo Tafoya on 4/10/25.
//

import SwiftUI

struct WelcomeView: View {
    @Binding var currentPage: OnboardingPage
    
    var body: some View {
            VStack {
                // Missing carousel displaying images of app features
                
                Spacer()
                
                Button {
                    currentPage = .authentication
                } label: {
                    Text("Continue")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.vertical, 13)
                        .padding(.horizontal, 50)
                        .foregroundColor(.black)
                        .background(.white)
                        .buttonStyle(.bordered)
                        .clipShape(.capsule)
                        .padding(.bottom, 70)
                }
                .sensoryFeedback(.impact, trigger: currentPage)
            }
    }
}

#Preview {
    @Previewable @State var currentPage: OnboardingPage = .welcome
    
    ZStack {
        Background()
        
        WelcomeView(currentPage: $currentPage)
    }
}

//
//  WelcomeView.swift
//  Villain-Arc
//
//  Created by Fernando Caudillo Tafoya on 4/10/25.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        ZStack {
            Background()
            
            VStack {
                Text("Villain Arc")
                    .font(.system(size: 52, weight: .semibold))
                    .foregroundStyle(.white)
                
                Spacer()
                
                // Missing carousel displaying images of app features
                
                Spacer()
                
                Button {
                    
                } label: {
                    Text("Continue")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 30)
                        .foregroundColor(.black)
                        .background(.white)
                        .buttonStyle(.bordered)
                        .clipShape(.capsule)
                }
            }
            .padding(.vertical, 30)
        }
    }
}

#Preview {
    WelcomeView()
}

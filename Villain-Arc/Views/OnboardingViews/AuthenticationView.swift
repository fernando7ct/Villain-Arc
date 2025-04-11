//
//  AuthenticationView.swift
//  Villain-Arc
//
//  Created by Fernando Caudillo Tafoya on 4/10/25.
//

import SwiftUI

struct AuthenticationView: View {
    var body: some View {
        VStack(spacing: 15) {
            Spacer()

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
            
            Button {
                
            } label: {
                Label("Sign in with Apple", systemImage: "apple.logo")
                    .signInButtonStyle()
            }
            
            Text("-Or-")
                .foregroundStyle(.white)
            
            Button {
                
            } label: {
                Label("Email/Password", systemImage: "envelope.fill")
                    .signInButtonStyle()
            }
            
            Spacer()
            Spacer()
        }
        .safeAreaPadding(.horizontal, 30)
    }
}

#Preview {
    ZStack {
        Background()
        
        AuthenticationView()
    }
}

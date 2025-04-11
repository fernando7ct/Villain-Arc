//
//  Entensions.swift
//  Villain-Arc
//
//  Created by Fernando Caudillo Tafoya on 4/10/25.
//

import SwiftUI

struct SignInButtonModifer: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title2)
            .foregroundStyle(.black)
            .fontWeight(.semibold)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

struct EmailPasswordButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .padding(.leading)
            .textFieldStyle(.plain)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(.white.opacity(0.25), style: .init(lineWidth: 3, lineCap: .round, lineJoin: .round))
            }
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .tint(.white)
    }
}

struct ContinueButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title3)
            .fontWeight(.semibold)
            .padding(.vertical, 13)
            .padding(.horizontal, 50)
            .foregroundColor(.black)
            .background(.white)
            .clipShape(.capsule)
    }
}

extension View {
    func signInButtonStyle() -> some View {
        self.modifier(SignInButtonModifer())
    }
    func emailPasswordButtonStyle() -> some View {
        self.modifier(EmailPasswordButtonModifier())
    }
    func continueButtonStyle() -> some View {
        self.modifier(ContinueButtonModifier())
    }
}


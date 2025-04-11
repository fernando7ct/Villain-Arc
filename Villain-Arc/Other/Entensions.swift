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
            .frame(maxWidth: .infinity, maxHeight: 55)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        
    }
}
extension View {
    func signInButtonStyle() -> some View {
        self.modifier(SignInButtonModifer())
    }
}

//
//  Background.swift
//  Villain-Arc
//
//  Created by Fernando Caudillo Tafoya on 4/10/25.
//

import SwiftUI

struct Background: View {
    var body: some View {
        ZStack {
            // Two options, "background1" or "background2"
            Image("background1")
                .resizable()
            
            Color.black.opacity(0.2)
        }
        .compositingGroup()
        .blur(radius: 60, opaque: true)
        .ignoresSafeArea()
    }
}

#Preview {
    Background()
}

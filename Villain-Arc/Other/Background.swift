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
            // Two options, must discuss which is better
            Image("background1")
                .resizable()
            
//            Image("background2")
//                .resizable()
            
            Color.black.opacity(0.1)
        }
        .compositingGroup()
        .blur(radius: 50, opaque: true)
        .ignoresSafeArea()
    }
}

#Preview {
    Background()
}

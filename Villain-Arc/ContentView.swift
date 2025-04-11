//
//  ContentView.swift
//  Villain-Arc
//
//  Created by Fernando Caudillo Tafoya on 4/10/25.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("userLoggedIn") var userLoggedIn: Bool = false
    
    var body: some View {
        Group {
            if userLoggedIn {
                
            } else {
                OnboardingView()
                    .transition(.blurReplace)
            }
        }
        .animation(.smooth, value: userLoggedIn)
    }
}

#Preview {
    ContentView()
}

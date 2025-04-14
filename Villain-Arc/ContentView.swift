//
//  ContentView.swift
//  Villain-Arc
//
//  Created by Fernando Caudillo Tafoya on 4/10/25.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("userLoggedIn") var userLoggedIn: Bool = false
    @State private var activeTab: Tab = .workout
    
    var body: some View {
        Group {
            if userLoggedIn {
                ZStack(alignment: .bottom) {
                    TabView(selection: $activeTab) {
                        WorkoutTab()
                            .tag(Tab.workout)
                            .toolbarVisibility(.hidden, for: .tabBar)
                        
                        HealthTab()
                            .tag(Tab.health)
                            .toolbarVisibility(.hidden, for: .tabBar)
                        
                        NutritionTab()
                            .tag(Tab.nutrition)
                            .toolbarVisibility(.hidden, for: .tabBar)
                        
                        RunTab()
                            .tag(Tab.run)
                            .toolbarVisibility(.hidden, for: .tabBar)
                        
                        ProfileTab()
                            .tag(Tab.profile)
                            .toolbarVisibility(.hidden, for: .tabBar)
                    }
                    
                    CustomTabBar(activeTab: $activeTab)
                        .padding(.bottom)
                }
            } else {
                WelcomeView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(\.colorScheme, .dark)
}

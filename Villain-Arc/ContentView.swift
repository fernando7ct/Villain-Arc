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
        if userLoggedIn {
            TabView(selection: $activeTab) {
                HealthTab()
                    .tag(Tab.health)
                    .tabItem {
                        Label(Tab.health.rawValue, systemImage: Tab.health.systemImage)
                    }
                
                WorkoutTab()
                    .tag(Tab.workout)
                    .tabItem {
                        Label(Tab.workout.rawValue, systemImage: Tab.workout.systemImage)
                    }
                
                NutritionTab()
                    .tag(Tab.nutrition)
                    .tabItem {
                        Label(Tab.nutrition.rawValue, systemImage: Tab.nutrition.systemImage)
                    }
            }
            .tint(.primary)
        } else {
            WelcomeView()
        }
    }
}

#Preview {
    ContentView()
}

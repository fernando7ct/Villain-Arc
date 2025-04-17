//
//  WorkoutTab.swift
//  Villain-Arc
//
//  Created by Fernando Caudillo Tafoya on 4/14/25.
//

import SwiftUI
import SwiftData

struct WorkoutTab: View {
    @Query private var workouts: [Workout]
    
    var body: some View {
        ZStack {
            Background()
            
            VStack {
                List(workouts) { workout in
                    Text(workout.title)
                }
                .scrollContentBackground(.hidden)
            }
        }
    }
}

#Preview {
    WorkoutTab()
        .environment(\.colorScheme, .dark)
}

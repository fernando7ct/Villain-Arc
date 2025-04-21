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
    @State private var startWorkout = false
    
    var body: some View {
        NavigationStack {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(workouts) {
                        WorkoutListDisplayView(workout: $0)
                            .containerRelativeFrame(.horizontal)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        startWorkout = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $startWorkout) {
            WorkoutView()
        }
    }
}

struct WorkoutListDisplayView: View {
    var workout: Workout
    
    var body: some View {
        VStack {
            Spacer()
            
            ForEach(workout.exercises.sorted(by: { $0.index < $1.index }).prefix(5)) { exercise in
                HStack(spacing: 1) {
                    Text("\(exercise.sets.count)x")
                        .fontWeight(.semibold)
                        .fontDesign(.rounded)
                    Text(exercise.name)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .fontWeight(.medium)
                }
                .hSpacing(.leading)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 160)
        .padding(9)
        .overlay(alignment: .trailing) {
            VStack(alignment: .trailing) {
                VStack(alignment: .trailing, spacing: 0) {
                    Text(workout.title)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .fontDesign(.rounded)
                    Text(workout.startTime, style: .date)
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                }
                Spacer()
                if workout.exercises.count > 5 {
                    let remaining = workout.exercises.count - 5
                    HStack(spacing: 3) {
                        Image(systemName: "plus")
                        Text(remaining, format: .number)
                    }
                    .font(.headline)
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
                }
            }
            .padding(9)
        }
        .background(.ultraThinMaterial, in: .rect(cornerRadius: 12))
        .padding(.horizontal)
    }
}

#Preview {
    TabView {
        WorkoutTab()
            .tabItem {
                Label(Tab.workout.rawValue, systemImage: Tab.workout.systemImage)
            }
    }
    .tint(.primary)
}

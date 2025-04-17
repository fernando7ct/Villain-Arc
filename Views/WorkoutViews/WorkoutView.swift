//
//  WorkoutView.swift
//  Villain-Arc
//
//  Created by Fernando Caudillo Tafoya on 4/16/25.
//

import SwiftUI

struct WorkoutView: View {
    @Binding var workout: Workout
    @State private var editingMode: Bool = false
    @State private var activeExercise: WorkoutExercise? = nil
    
    var body: some View {
        ZStack {
            Background()
            
            VStack {
                if !editingMode {
                    Text(workout.title)
                        .font(.title)
                    
                    Button {
                        let count = workout.exercises.count
                        withAnimation {
                            workout.exercises.append(.init(id: UUID().uuidString, name: "Test Exercise \(count)"))
                        }
                    } label: {
                        Text("Add Exercise")
                    }
                    TabView(selection: $activeExercise) {
                        ForEach(workout.exercises) { exercise in
                            Text(exercise.name)
                                .tag(exercise)
                        }
                    }
                    .tabViewStyle(.page)
                } else {
                    List {
                        ForEach(workout.exercises) { exercise in
                            Text(exercise.name)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .safeAreaInset(edge: .bottom) {
                Button("Edit") {
                    editingMode.toggle()
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var workout: Workout = .init(id: UUID().uuidString, title: "Test", isComplete: false, exercises: [])
    
    WorkoutView(workout: $workout)
        .environment(\.colorScheme, .dark)
}

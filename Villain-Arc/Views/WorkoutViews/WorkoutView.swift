//
//  WorkoutView.swift
//  Villain-Arc
//
//  Created by Fernando Caudillo Tafoya on 4/16/25.
//

import SwiftUI
import SwiftData

struct WorkoutView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var editingMode: Bool = false
    @State private var activeExercise: TempExercise? = nil
    @State private var workout: ActiveWorkout = ActiveWorkout()
    
    init(existingWorkout: Workout? = nil) {
        if let existingWorkout {
            workout = ActiveWorkout(workout: existingWorkout)
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Background()
            
            VStack {
                header()
                if !editingMode {
                    TabView {
                        ForEach(workout.exercises) { exercise in
                            Text(exercise.name)
                               
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                } else {
                    List {
                        ForEach(workout.exercises) { exercise in
                            Text(exercise.name)
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            
            bottomBar()
        }
    }
    
    @ViewBuilder
    private func bottomBar() -> some View {
        HStack {
            Button {
                withAnimation {
                    editingMode.toggle()
                }
            } label: {
                Image(systemName: "list.bullet")
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .font(.title3)
                    .padding()
                    .background(.black.opacity(0.2))
                    .clipShape(.circle)
            }
            .buttonBorderShape(.circle)
            
            Spacer()
            Button {
                let count = workout.exercises.count + 1
                workout.addExercise(TempExercise(name: "Exercise \(count)"))
            } label: {
                Label("Exercise", systemImage: "plus")
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .font(.title3)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 40)
                    .background(.black.opacity(0.2))
                    .clipShape(.capsule)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Button {
                
            } label: {
                Image(systemName: "chevron.up")
                    .foregroundStyle(.white)
                    .fontWeight(.semibold)
                    .font(.title3)
                    .padding()
                    .background(.black.opacity(0.2))
                    .clipShape(.circle)
            }
            .buttonBorderShape(.circle)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    private func header() -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(workout.title)
                    .font(.title)
                    .fontWeight(.semibold)
                Text(.now, style: .date)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if workout.resting {
                Text(workout.endOfRest, style: .timer)
                    .font(.title2)
                    .padding()
                    .background(.black.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

#Preview {
    WorkoutView()
        .environment(\.colorScheme, .dark)
}

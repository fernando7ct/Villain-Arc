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
    @State private var selectedExerciseIndex: Int? = nil
    @State private var workout: ActiveWorkout = ActiveWorkout()
    
    init(existingWorkout: Workout? = nil) {
        if let existingWorkout {
            workout = ActiveWorkout(workout: existingWorkout)
        }
    }
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            ZStack(alignment: .bottom) {
                Background()
                
                if !editingMode {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(workout.exercises.indices, id: \.self) { idx in
                                ExerciseDetailView(workout: workout, exercise: $workout.exercises[idx])
                                    .containerRelativeFrame(.horizontal)
                                    .id(idx)
                            }
                        }
                    }
                    .scrollDisabled(!editingMode)
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(workout.exercises.indices, id: \.self) { idx in
                                Button {
                                    withAnimation {
                                        selectedExerciseIndex = idx
                                        editingMode = false
                                    }
                                } label: {
                                    HStack {
                                        Text(workout.exercises[idx].name)
                                            .font(.headline)
                                            .foregroundStyle(.primary)
                                        Spacer()
                                        Text(workout.exercises[idx].sets.map { "\($0.reps)x\($0.weight)" }.joined(separator: " • "))
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(.black.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                    }
                }
                
                bottomBar()
            }
            .onChange(of: selectedExerciseIndex) {
                if let selectedExerciseIndex {
                    withAnimation {
                        scrollProxy.scrollTo(selectedExerciseIndex)
                    }
                }
            }
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
                    .background(.black.opacity(0.4), in: .circle)
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
                    .background(.black.opacity(0.4), in: .capsule)
                    .lineLimit(1)
            }
            .buttonBorderShape(.capsule)
            
            Spacer()
            
            Button {
                
            } label: {
                Image(systemName: "chevron.up")
                    .foregroundStyle(.white)
                    .fontWeight(.semibold)
                    .font(.title3)
                    .padding()
                    .background(.black.opacity(0.4), in: .circle)
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

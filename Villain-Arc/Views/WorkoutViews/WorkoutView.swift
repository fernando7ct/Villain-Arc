//
//  WorkoutView.swift
//  Villain-Arc
//
//  Created by Fernando Caudillo Tafoya on 4/16/25.
//

import SwiftUI

struct WorkoutView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var editingMode: Bool = false
    @State private var workout: ActiveWorkout = ActiveWorkout()
    @State private var displayWorkoutSettingsSheet: Bool = true
    
    init(existingWorkout: Workout? = nil) {
        if let existingWorkout {
            workout = ActiveWorkout(workout: existingWorkout)
        }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if !editingMode {
                    TabView {
                        ForEach($workout.exercises) {
                            ExerciseDetailView(workout: workout, exercise: $0)
                                .toolbarVisibility(.hidden, for: .tabBar)
                        }
                        
                        ContentUnavailableView("No exercises added yet.", systemImage: "xmark")
                            .toolbarVisibility(.hidden, for: .tabBar)
                    }
                } else {
                    ScrollView(showsIndicators: false) {
                        ForEach(workout.exercises) { exercise in
                            Button {
                                
                            } label: {
                                HStack {
                                    Text(exercise.name)
                                }
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    bottomBar()
                }
            }
            .toolbarBackgroundVisibility(.visible, for: .bottomBar)
            .sheet(isPresented: $displayWorkoutSettingsSheet) {
                workoutSettingsView()
                    .presentationDetents([.height(300)])
                    .presentationCornerRadius(20)
                    .presentationBackground(.ultraThinMaterial)
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
                    .padding()
                    .workoutBottomButtonStyle(.circle)
            }
            .buttonBorderShape(.circle)
            .hSpacing(.leading)
            
            Button {
                let count = workout.exercises.count + 1
                workout.addExercise(TempExercise(name: "Exercise \(count)"))
            } label: {
                Label("Exercise", systemImage: "plus")
                    .padding(.vertical, 10)
                    .padding(.horizontal, 40)
                    .workoutBottomButtonStyle(.capsule)
                    .labelStyle(.iconOnly)
            }
            .buttonBorderShape(.capsule)
            
            Button {
                displayWorkoutSettingsSheet = true
            } label: {
                Image(systemName: "chevron.up")
                    .padding()
                    .workoutBottomButtonStyle(.circle)
            }
            .buttonBorderShape(.circle)
            .hSpacing(.trailing)
        }
        .padding(.top)
    }
    
    @ViewBuilder
    private func workoutSettingsView() -> some View {
        VStack(spacing: 15) {
            TextField("Workout Title", text: $workout.title)
                .padding()
                .background(.black.opacity(0.1), in: .rect(cornerRadius: 12))
            
            DatePicker("Start Time", selection: $workout.startTime, displayedComponents: .hourAndMinute)
                .padding()
                .background(.black.opacity(0.1), in: .rect(cornerRadius: 12))
            
            HStack(spacing: 20) {
                Button {
                    
                } label: {
                    Text("Cancel Workout")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                        .background(.red, in: .rect(cornerRadius: 12))
                }
                
                Button {
                    
                } label: {
                    Text("Save Workout")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                        .background(.green, in: .rect(cornerRadius: 12))
                }
            }
            
            Spacer()
            
        }
        .padding()
    }
}

#Preview {
    WorkoutView()
}

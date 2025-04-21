//
//  WorkoutView.swift
//  Villain-Arc
//
//  Created by Fernando Caudillo Tafoya on 4/16/25.
//

import SwiftUI

struct WorkoutView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var editingMode: Bool = false
    @State private var workout: ActiveWorkout = ActiveWorkout()
    @State private var displayWorkoutSettingsSheet: Bool = false
    @State private var displayAddExerciseSheet: Bool = false
    
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
                    .presentationDetents([.height(280)])
                    .presentationCornerRadius(12)
            }
            .sheet(isPresented: $displayAddExerciseSheet) {
                ExerciseSelectionView(workout: $workout)
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
                displayAddExerciseSheet = true
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
                .background(.black.opacity(0.15), in: .rect(cornerRadius: 12))
                .padding(.top)
            
            DatePicker("Start Time", selection: $workout.startTime, displayedComponents: .hourAndMinute)
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(.black.opacity(0.15), in: .rect(cornerRadius: 12))
            DatePicker("End Time", selection: $workout.endTime, in: workout.startTime...Date(), displayedComponents: .hourAndMinute)
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(.black.opacity(0.15), in: .rect(cornerRadius: 12))
            
            HStack(spacing: 20) {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel Workout")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                        .background(.red, in: .rect(cornerRadius: 12))
                }
                .buttonBorderShape(.roundedRectangle(radius: 12))
                
                Button {
                    workout.saveWorkout(modelContext)
                    dismiss()
                } label: {
                    Text("Save Workout")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                        .background(.green, in: .rect(cornerRadius: 12))
                }
                .buttonBorderShape(.roundedRectangle(radius: 12))
                .disabled(workout.title.isEmpty)
                .opacity(workout.title.isEmpty ? 0.8 : 1)
            }
        }
        .padding()
        .onAppear {
            workout.endTime = Date()
        }
        .vSpacing(.top)
    }
}

#Preview {
    WorkoutView()
}


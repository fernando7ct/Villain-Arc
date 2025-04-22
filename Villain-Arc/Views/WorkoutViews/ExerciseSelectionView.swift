//
//  ExerciseSelectionView.swift
//  Villain-Arc
//
//  Created by Fernando Caudillo Tafoya on 4/21/25.
//

import SwiftUI

struct ExerciseSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var workout: ActiveWorkout
    @State private var searchText: String = ""
    @State private var exercises: [Exercise] = Bundle.main.decode("exercises.json")
    @State private var selectedIDs: Set<String> = []
    @State private var sortAscending: Bool = true
    @State private var showAddedOnly: Bool = false
    @State private var selectedMuscleGroups: Set<String> = []
    private let allMuscleGroups: [String] = ["Chest", "Shoulders", "Biceps", "Triceps", "Legs", "Glutes", "Back", "Abs", "Calves", "Forearms"]
    
    private var filteredExercises: [Exercise] {
        var list = exercises
        if showAddedOnly {
            list = list.filter { selectedIDs.contains($0.id) }
        }
        if !searchText.isEmpty {
            list = list.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        list = list.filter { selectedMuscleGroups.contains($0.muscleTargeted) }
        list.sort {
            sortAscending ? $0.name < $1.name : $0.name > $1.name
        }
        return list
    }
    
    private func toggleSelection(_ exercise: Exercise) {
        let eid = exercise.id
        if selectedIDs.contains(eid) {
            selectedIDs.remove(eid)
            workout.exercises.removeAll { $0.id == eid }
        } else {
            selectedIDs.insert(eid)
            workout.addExercise(TempExercise(exercise: exercise))
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
        }
    }
    
    var body: some View {
        NavigationStack {
            List(filteredExercises, id: \.id) { exercise in
                HStack {
                    VStack(alignment: .leading) {
                        Text(exercise.name)
                            .fontWeight(.semibold)
                        Text(exercise.muscleTargeted)
                            .foregroundStyle(.secondary)
                            .font(.callout)
                    }
                    
                    Spacer()
                    
                    Button {
                        toggleSelection(exercise)
                    } label: {
                        let isSelected = selectedIDs.contains(exercise.id)
                        Image(systemName: isSelected ? "checkmark" : "plus")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(8)
                            .background(.ultraThinMaterial, in: .circle)
                            .foregroundStyle(isSelected ? .green : .blue)
                    }
                    .buttonBorderShape(.circle)
                }
            }
            .animation(.smooth, value: searchText)
            .listRowSpacing(8)
            .searchable(text: $searchText)
            .navigationTitle("Exercises")
            .navigationBarTitleDisplayMode(.inline)
            .persistentSystemOverlays(.hidden)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Menu("Name") {
                            Button {
                                sortAscending = true
                            } label: {
                                Label("Ascending (A - Z)", systemImage: sortAscending ? "checkmark" : "")
                            }
                            Button {
                                sortAscending = false
                            } label: {
                                Label("Descending (Z - A)", systemImage: !sortAscending ? "checkmark" : "")
                            }
                        }
                        Menu("Muscle Groups") {
                            Button {
                                selectedMuscleGroups = Set(allMuscleGroups)
                            } label: {
                                Label("All", systemImage: selectedMuscleGroups.count == allMuscleGroups.count ? "checkmark" : "")
                            }

                            Divider()

                            ForEach(allMuscleGroups, id: \.self) { group in
                                Button {
                                    if selectedMuscleGroups.contains(group) {
                                        selectedMuscleGroups.remove(group)
                                    } else {
                                        selectedMuscleGroups.insert(group)
                                    }
                                } label: {
                                    Label(group, systemImage: selectedMuscleGroups.contains(group) ? "checkmark" : "")
                                }
                            }
                        }
                        Divider()
                        Toggle("Show Added Only", isOn: $showAddedOnly)
                    } label: {
                        Text("Sort")
                            .foregroundStyle(.blue)
                            .font(.title3)
                    }
                }
            }
            .onAppear {
                if selectedMuscleGroups.isEmpty {
                    selectedMuscleGroups = Set(allMuscleGroups)
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var workout: ActiveWorkout = .init()
    
    ExerciseSelectionView(workout: $workout)
}

//
//  ActiveWorkout.swift
//  Villain-Arc
//
//  Created by Fernando Caudillo Tafoya on 4/16/25.
//

import SwiftUI
import SwiftData

@Observable class ActiveWorkout {
    var id: String = UUID().uuidString
    var title: String = "New Workout"
    var startTime: Date = Date()
    var endTime: Date = Date()
    var notes: String = ""
    var exercises: [TempExercise] = []
    var endOfRest: Date = Date()
    var resting: Bool  {
        self.endOfRest > Date()
    }
    
    init() {
        print("New Active Workout")
    }
    
    init(workout: Workout) {
        self.title = workout.title
        self.notes = workout.notes
        self.exercises = workout.exercises
            .sorted { $0.index < $1.index }
            .map { TempExercise(exercise: $0) }
        print("New active workout from existing workout")
    }
    
    func addExercise(_ exercise: TempExercise) {
        self.exercises.append(exercise)
    }
    
    func saveWorkout(_ modelContext: ModelContext) {
        let newWorkout = Workout(workout: self)
        modelContext.insert(newWorkout)
        print("workout saved")
    }
}

class TempExercise: Identifiable {
    var id: String = UUID().uuidString
    var name: String = ""
    var muscleTargeted: String = ""
    var repRange: String = ""
    var notes: String = ""
    var sets: [TempSet] = []
    
    init(id: String = UUID().uuidString, name: String = "", muscleTargeted: String = "", repRange: String = "", notes: String = "", sets: [TempSet] = []) {
        self.id = id
        self.name = name
        self.muscleTargeted = muscleTargeted
        self.repRange = repRange
        self.notes = notes
        self.sets = sets
    }
    
    init(exercise: WorkoutExercise) {
        self.name = exercise.name
        self.muscleTargeted = exercise.muscleTargeted
        self.repRange = exercise.repRange
        self.notes = exercise.notes
        self.sets = exercise.sets
            .sorted { $0.index < $1.index }
            .map { TempSet(set: $0) }
    }
    
    init(exercise: Exercise) {
        self.id = exercise.id
        self.name = exercise.name
        self.muscleTargeted = exercise.muscleTargeted
        self.sets = [TempSet()]
    }
}

class TempSet: Identifiable {
    var id: String = UUID().uuidString
    var reps: Double = 0
    var weight: Double = 0
    var complete: Bool = false
    
    init(id: String = UUID().uuidString, reps: Double = 0, weight: Double = 0, complete: Bool = false) {
        self.id = id
        self.reps = reps
        self.weight = weight
        self.complete = complete
    }
    
    init(set: ExerciseSet) {
        self.reps = set.reps
        self.weight = set.weight
    }
}

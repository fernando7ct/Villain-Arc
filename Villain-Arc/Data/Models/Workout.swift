//
//  Workout.swift
//  Villain-Arc
//
//  Created by Fernando Caudillo Tafoya on 4/16/25.
//

import SwiftUI
import SwiftData

@Model
class Workout {
    var id: String = UUID().uuidString
    var title: String = ""
    var startTime: Date = Date()
    var endTime: Date = Date()
    var notes: String = ""
    @Relationship(deleteRule: .cascade) var exercises: [WorkoutExercise] = []
    
    init(id: String = UUID().uuidString, title: String, startTime: Date, endTime: Date, notes: String, exercises: [WorkoutExercise]) {
        self.id = id
        self.title = title
        self.startTime = startTime
        self.endTime = endTime
        self.notes = notes
        self.exercises = exercises
    }
    
    init(workout: ActiveWorkout) {
        self.id = workout.id
        self.title = workout.title
        self.startTime = workout.startTime
        self.endTime = workout.endTime
        self.notes = workout.notes
        self.exercises = workout.exercises
            .enumerated()
            .map { index, exer in
                WorkoutExercise(exercise: exer, index: index)
            }
    }
}

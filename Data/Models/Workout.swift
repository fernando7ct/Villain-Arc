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
    var isComplete: Bool = false
    var exercises: [WorkoutExercise] = []
    
    init(id: String, title: String, isComplete: Bool, exercises: [WorkoutExercise]) {
        self.id = id
        self.title = title
        self.isComplete = isComplete
        self.exercises = exercises
    }
}

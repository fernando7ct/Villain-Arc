//
//  WorkoutExercise.swift
//  Villain-Arc
//
//  Created by Fernando Caudillo Tafoya on 4/16/25.
//

import SwiftUI
import SwiftData

@Model
class WorkoutExercise {
    var id: String = UUID().uuidString
    var name: String = ""
    var sets: [ExerciseSet] = []
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

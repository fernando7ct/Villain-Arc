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
    var musclesTargeted: [String] = []
    var repRange: String = ""
    var notes: String = ""
    var index: Int = 0
    var sets: [ExerciseSet] = []
    
    init(id: String, name: String, musclesTargeted: [String], repRange: String, notes: String, index: Int, sets: [ExerciseSet]) {
        self.id = id
        self.name = name
        self.musclesTargeted = musclesTargeted
        self.repRange = repRange
        self.notes = notes
        self.index = index
        self.sets = sets
    }
    
    init(exercise: TempExercise, index: Int) {
        self.id = exercise.id
        self.name = exercise.name
        self.musclesTargeted = exercise.musclesTargeted
        self.repRange = exercise.repRange
        self.notes = exercise.notes
        self.index = index
        self.sets = exercise.sets
            .enumerated()
            .map { setIndex, temp in
                ExerciseSet(set: temp, index: setIndex)
            }
    }
}

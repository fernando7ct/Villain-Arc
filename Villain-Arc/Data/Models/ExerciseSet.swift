//
//  ExerciseSet.swift
//  Villain-Arc
//
//  Created by Fernando Caudillo Tafoya on 4/16/25.
//

import SwiftUI
import SwiftData

@Model
class ExerciseSet {
    var id: String = UUID().uuidString
    var index: Int = 0
    var weight: Double = 0
    var reps: Double = 0
    var complete: Bool = false
    
    init(id: String, index: Int, weight: Double, reps: Double, complete: Bool) {
        self.id = id
        self.index = index
        self.weight = weight
        self.reps = reps
        self.complete = complete
    }
    
    init(set: TempSet, index: Int) {
        self.id = set.id
        self.index = index
        self.reps = set.reps
        self.weight = set.weight
        self.complete = set.complete
    }
}

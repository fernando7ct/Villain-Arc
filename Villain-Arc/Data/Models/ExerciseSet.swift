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
    var setNumber: Int
    var weight: Double
    var reps: Int
    
    
    init(id: String = UUID().uuidString, setNumber: Int, weight: Double, reps: Int) {
        self.setNumber = setNumber
        self.weight = weight
        self.reps = reps
        self.id = id
    }
}

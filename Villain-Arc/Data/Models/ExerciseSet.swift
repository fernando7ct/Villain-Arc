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
    
    init(id: String) {
        self.id = id
    }
}

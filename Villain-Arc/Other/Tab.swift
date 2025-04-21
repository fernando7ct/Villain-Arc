//
//  Tab.swift
//  Villain-Arc
//
//  Created by Fernando Caudillo Tafoya on 4/14/25.
//

import SwiftUI

enum Tab: String {
    case workout = "Workout"
    case health = "Health"
    case nutrition = "Nutrition"
    
    var systemImage: String {
        switch self {
        case .workout: "figure.strengthtraining.traditional"
        case .health: "heart.text.square.fill"
        case .nutrition: "fork.knife"
        }
    }
}

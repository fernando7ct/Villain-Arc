//
//  Tab.swift
//  Villain-Arc
//
//  Created by Fernando Caudillo Tafoya on 4/14/25.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case workout = "figure.strengthtraining.traditional"
    case health = "heart.text.square.fill"
    case nutrition = "leaf.fill"
    case run = "figure.run"
    case profile = "person.fill"
    
    var title: String {
        switch self {
        case .workout: "Workout"
        case .health: "Health"
        case .nutrition: "Nutrition"
        case .run: "Run"
        case .profile: "Profile"
        }
    }
    
    var systemImage: String {
        switch self {
        case .workout, .run, .nutrition: "plus"
        case .profile: "gear"
        case .health: "slider.horizontal.3"
        }
    }
}

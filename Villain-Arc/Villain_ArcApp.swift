//
//  Villain_ArcApp.swift
//  Villain-Arc
//
//  Created by Fernando Caudillo Tafoya on 4/10/25.
//

import SwiftUI
import Firebase
import SwiftData

@main
struct Villain_ArcApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.colorScheme, .dark)
        }
        .modelContainer(for: [User.self])
    }
}

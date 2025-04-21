//
//  ExerciseSelectionView.swift
//  Villain-Arc
//
//  Created by Fernando Caudillo Tafoya on 4/21/25.
//

import SwiftUI

struct ExerciseSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var workout: ActiveWorkout
    @State private var searchText: String = ""
    var body: some View {
        NavigationStack {
            List {
                HStack {
                    Text("Exercise 1")
                    Spacer()
                    Button {
                        
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .searchable(text: $searchText)
            .navigationTitle("Exercises")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    @Previewable @State var workout: ActiveWorkout = .init()
    
    ExerciseSelectionView(workout: $workout)
}

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
    var startTime: Date = Date()
    var endTime: Date = Date()
    var notes: String = ""
    @Relationship(deleteRule: .cascade) var exercises: [WorkoutExercise] = []
    
    init(id: String = UUID().uuidString, title: String, startTime: Date, endTime: Date, notes: String, exercises: [WorkoutExercise]) {
        self.id = id
        self.title = title
        self.startTime = startTime
        self.endTime = endTime
        self.notes = notes
        self.exercises = exercises
    }
    
    init(workout: ActiveWorkout) {
        self.id = workout.id
        self.title = workout.title
        self.startTime = workout.startTime
        self.endTime = workout.endTime
        self.notes = workout.notes
        self.exercises = workout.exercises
            .enumerated()
            .map { index, exer in
                WorkoutExercise(exercise: exer, index: index)
            }
    }
    
    static var testingData: [Workout] {
        [
            Workout(
                title: "Chest Day",
                startTime: Date().addingTimeInterval(-3600),
                endTime: Date(),
                notes: "Focus on form",
                exercises: [
                    WorkoutExercise(
                        id: UUID().uuidString,
                        name: "Bench Press",
                        musclesTargeted: ["Chest", "Triceps"],
                        repRange: "8-10",
                        notes: "Control the weight",
                        index: 0,
                        sets: [ExerciseSet(id: UUID().uuidString, index: 0, weight: 135, reps: 8, complete: false)]
                    ),
                    WorkoutExercise(
                        id: UUID().uuidString,
                        name: "Incline Dumbbell Press",
                        musclesTargeted: ["Upper Chest"],
                        repRange: "10-12",
                        notes: "Squeeze at the top",
                        index: 1,
                        sets: [ExerciseSet(id: UUID().uuidString, index: 0, weight: 40, reps: 10, complete: false)]
                    ),
                    WorkoutExercise(
                        id: UUID().uuidString,
                        name: "Incline Dumbbell Press",
                        musclesTargeted: ["Upper Chest"],
                        repRange: "10-12",
                        notes: "Squeeze at the top",
                        index: 1,
                        sets: [ExerciseSet(id: UUID().uuidString, index: 0, weight: 40, reps: 10, complete: false)]
                    ),
                    WorkoutExercise(
                        id: UUID().uuidString,
                        name: "Incline Dumbbell Press",
                        musclesTargeted: ["Upper Chest"],
                        repRange: "10-12",
                        notes: "Squeeze at the top",
                        index: 1,
                        sets: [ExerciseSet(id: UUID().uuidString, index: 0, weight: 40, reps: 10, complete: false)]
                    ),
                    WorkoutExercise(
                        id: UUID().uuidString,
                        name: "Incline Dumbbell Press",
                        musclesTargeted: ["Upper Chest"],
                        repRange: "10-12",
                        notes: "Squeeze at the top",
                        index: 1,
                        sets: [ExerciseSet(id: UUID().uuidString, index: 0, weight: 40, reps: 10, complete: false)]
                    ),
                    WorkoutExercise(
                        id: UUID().uuidString,
                        name: "Incline Dumbbell Press",
                        musclesTargeted: ["Upper Chest"],
                        repRange: "10-12",
                        notes: "Squeeze at the top",
                        index: 1,
                        sets: [ExerciseSet(id: UUID().uuidString, index: 0, weight: 40, reps: 10, complete: false)]
                    )
                ]
            ),
            Workout(
                title: "Leg Day",
                startTime: Date().addingTimeInterval(-7200),
                endTime: Date().addingTimeInterval(-3600),
                notes: "Use full range of motion",
                exercises: [
                    WorkoutExercise(
                        id: UUID().uuidString,
                        name: "Squats",
                        musclesTargeted: ["Quads", "Glutes"],
                        repRange: "10-12",
                        notes: "Go below parallel",
                        index: 0,
                        sets: [ExerciseSet(id: UUID().uuidString, index: 0, weight: 185, reps: 10, complete: false)]
                    ),
                    WorkoutExercise(
                        id: UUID().uuidString,
                        name: "Lunges",
                        musclesTargeted: ["Glutes", "Hamstrings"],
                        repRange: "12-15",
                        notes: "Keep balance",
                        index: 1,
                        sets: [ExerciseSet(id: UUID().uuidString, index: 0, weight: 40, reps: 12, complete: false)]
                    )
                ]
            )
        ]
    }
}

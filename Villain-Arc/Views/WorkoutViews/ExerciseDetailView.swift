//
//  ExerciseDetailView.swift
//  Villain-Arc
//
//  Created by Fernando Caudillo Tafoya on 4/16/25.


import SwiftUI
import Foundation

struct ExerciseDetailView: View {
    @Binding var exercise: WorkoutExercise
    
    // Timer
    @State private var timeElapsed: Int = 0
    @State private var timerRunning: Bool = false
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            Background()

            ScrollView {
                VStack(alignment: .center, spacing: 15) {
                    // Timer
                    Text(String(format: "%02d:%02d", timeElapsed / 60, timeElapsed % 60))
                        .font(.system(size: 48, weight: .bold, design: .monospaced))
                        .padding(.bottom, 10)
                        .onReceive(timer) { _ in
                            if timerRunning { timeElapsed += 1 }
                        }

                    // Exercise title
                    Text(exercise.name)
                        .font(.largeTitle).bold()
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 20)

                    // Header
                    HStack(spacing: 8) {
                        Text("SET").bold().frame(width: 50)
                        Text("PREV").bold().frame(width: 80)
                        Text("LBS").bold().frame(width: 60)
                        Text("REPS").bold().frame(width: 60)
                    }

                    // ── editable rows ────────────────────────
                    ForEach($exercise.sets) { $set in
                        let prevString = "\(Int(set.weight))x\(set.reps)"

                        HStack(spacing: 8) {
                            Text("\(set.setNumber)").frame(width: 50)

                            Text(prevString)
                                .frame(width: 80)

                            TextField("lbs", value: $set.weight, format: .number)
                                .frame(width: 60)
                                .textFieldStyle(.roundedBorder)

                            TextField("reps", value: $set.reps, format: .number)
                                .frame(width: 60)
                                .textFieldStyle(.roundedBorder)
                        }
                    }

                    // Add‑Set button
                    Button {
                        let next = exercise.sets.count + 1
                        exercise.sets.append(
                            ExerciseSet(setNumber: next, weight: 0, reps: 0)
                        )
                        timerRunning = true
                    } label: {
                        Label("Add Set", systemImage: "plus")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.vertical, 8)
                }
                .padding(.top, 40)
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .center)
                .onAppear {
                    // ensure a new exercise starts with three blank sets
                    if exercise.sets.isEmpty {
                        for i in 1...3 {
                            exercise.sets.append(
                                ExerciseSet(setNumber: i, weight: 0, reps: 0)
                            )
                        }
                    }
                    timeElapsed = 0            // reset
                    timerRunning = true        // start timer immediately when view appears
                }
            } // end ScrollView

            // Bottom‑pinned “Log” button
            .safeAreaInset(edge: .bottom) {
                Button {
                    
                    timerRunning = false
                } label: {
                    Text("LOG")
                        .font(.title3.bold())
                        .padding(.vertical, 10)
                        .padding(.horizontal, 60)
                        .background(Color.brown)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(radius: 4)
                }
                .padding(.horizontal)
            }
        }
    }
}

// ── preview ───────────────────────────────────────────────────
#Preview {
    @Previewable @State var exercise = WorkoutExercise(
        id: UUID().uuidString,
        name: "Bench Press DB",
        sets: (1...8).map { i in
            ExerciseSet(
                setNumber: i,
                weight: 95.0 + Double(i - 1) * 10,   // 95, 105, 115 …
                reps: max(12 - (i - 1) * 2, 3)       // 12, 10, 8 …
            )
        }
    )

    ExerciseDetailView(exercise: $exercise)
        .environment(\.colorScheme, .dark)
}

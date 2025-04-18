//
//  ExerciseDetailView.swift
//  Villain-Arc
//
//  Created by Fernando Caudillo Tafoya on 4/16/25.


import SwiftUI

struct ExerciseDetailView: View {
    var workout: ActiveWorkout
    @Binding var exercise: TempExercise
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            HStack {
                VStack(alignment: .leading) {
                    Text(exercise.name)
                        .font(.title)
                        .fontWeight(.semibold)
                }
                Spacer()
                if workout.resting {
                    Text(workout.endOfRest, style: .timer)
                        .font(.title2)
                        .padding()
                        .background(.black.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .heavyBlurScroll()
            
            HStack {
                Text("Set")
                    .padding(.horizontal, 7)
                Text("Reps")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Weight")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Previous")
                    .frame(maxWidth: .infinity, alignment: .center)
                Text("")
                    .frame(width: 55)
            }
            .font(.headline)
            .foregroundStyle(.secondary)
            .heavyBlurScroll()
            
            ForEach(Array($exercise.sets.enumerated()), id: \.element.id) { index, set in
                HStack {
                    Text(index + 1, format: .number)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.leading)
                        .padding(.trailing, 20)
                    TextField("Reps", value: set.reps, format: .number)
                        .font(.title3)
                        .fontWeight(.semibold)
                    TextField("Weight", value: set.weight, format: .number)
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text("8x125")
                        .lineLimit(1)
                        .padding(.trailing)
                        .fontWeight(.semibold)
                    Button {
                        
                    } label: {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.green)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                    }
                }
                .padding(.bottom)
                .heavyBlurScroll()
            }
            Button {
                exercise.sets.append(TempSet())
            } label: {
                Label("Add Set", systemImage: "plus")
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background(.black.opacity(0.4), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
            .padding(.horizontal)
            .heavyBlurScroll()
            
            Text("")
                .frame(height: 50)
        }
    }
}

#Preview {
    @Previewable @State var exercise: TempExercise = TempExercise()
    
    ZStack {
        Background()
        
        ExerciseDetailView(workout: ActiveWorkout(), exercise: $exercise)
            .environment(\.colorScheme, .dark)
    }
}

//
//  ProfileTab.swift
//  Villain-Arc
//
//  Created by Fernando Caudillo Tafoya on 4/14/25.
//

import SwiftUI
import SwiftData

struct ProfileTab: View {
    @Query private var users: [User]
    
    private var user: User {
        users.first ?? User(id: UUID().uuidString, firstName: "Fernando", lastName: "Caudillo Tafoya", username: "fernando7ct", dateJoined: Date(), birthday: Date())
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Background()
                
                ScrollView {
                    VStack(spacing: 30) {
                        VStack(spacing: 5) {
                            Image(systemName: "person.fill")
                                .font(.largeTitle)
                                .padding(15)
                                .background(.black.opacity(0.2), in: .circle)
                                .blurScroll()
                            
                            Text("@\(user.username)")
                                .fontWeight(.semibold)
                                .font(.title3)
                                .blurScroll()
                        }
                        
                        HStack(spacing: 60) {
                            VStack(alignment: .center) {
                                Text("123")
                                    .fontWeight(.semibold)
                                    .font(.title2)
                                Text("Workouts")
                                    .foregroundStyle(.gray)
                            }
                            VStack(alignment: .center) {
                                Text("269")
                                    .fontWeight(.semibold)
                                    .font(.title2)
                                Text("Runs")
                                    .foregroundStyle(.gray)
                            }
                            VStack(alignment: .center) {
                                Text("7 days")
                                    .fontWeight(.semibold)
                                    .font(.title2)
                                Text("Streak")
                                    .foregroundStyle(.gray)
                            }
                        }
                        .blurScroll()
                    }
                }
                .contentMargins(.top, 20)
            }
        }
    }
}

#Preview {
    ProfileTab()
        .environment(\.colorScheme, .dark)
}

//
//  CustomTabBar.swift
//  Villain-Arc
//
//  Created by Fernando Caudillo Tafoya on 4/14/25.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var activeTab: Tab
    @Namespace private var animation
    
    var body: some View {
        HStack(spacing: 12) {
            HStack(spacing: 0) {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Button {
                        activeTab = tab
                    } label: {
                        HStack(spacing: 5) {
                            Image(systemName: tab.rawValue)
                                .font(.title3)
                                .fontWeight(.bold)
                                .frame(width: 30, height: 30)
                            if activeTab == tab {
                                Text(tab.title)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                            }
                        }
                        .foregroundStyle(activeTab == tab ? .black : .gray)
                        .padding(.vertical, 2)
                        .padding(.leading, 12)
                        .padding(.trailing, 17)
                        .contentShape(.rect)
                        .background {
                            if activeTab == tab {
                                Capsule()
                                    .fill(.white)
                                    .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 5)
            .frame(height: 45)
            .background(.black.opacity(0.1), in: .capsule)
            
            Button {
                
            } label: {
                Image(systemName: activeTab.systemImage)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .frame(width: 40, height: 40)
                    .foregroundStyle(.white)
                    .background(.black.opacity(0.1), in: .circle)
            }
            .transition(.blurReplace)
        }
        .padding(.bottom, 8)
        .animation(.smooth(duration: 0.3, extraBounce: 0), value: activeTab)
    }
}

#Preview {
    ContentView()
        .environment(\.colorScheme, .dark)
}

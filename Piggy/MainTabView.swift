//
//  MainTabView.swift
//  Piggy
//
//  Created by Pedro on 1/6/25.
//


import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Piggy", systemImage: "dollarsign.circle.fill")
                }
            
            SavingsMethodsView()
                .tabItem {
                    Label("Save", systemImage: "leaf.fill")
                }
            
            GoalsView()
                .tabItem {
                    Label("Goals", systemImage: "target")
                }
        }
        .tint(.blue)
    }
}
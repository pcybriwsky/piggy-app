//
//  HomeView.swift
//  Piggy
//
//  Created by Pedro on 1/6/25.
//


import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var dataManager: DataManager
    @State private var showingAddSavings = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.pink)
                
                Text("Your Piggy Bank")
                    .font(.custom("Courier", size: 24))
                
                if dataManager.goals.isEmpty {
                    // Fallback for iOS 16
                    VStack {
                        Image(systemName: "target")
                            .font(.system(size: 50))
                            .foregroundColor(.secondary)
                        Text("Add a goal to start saving!")
                            .font(.headline)
                        Text("Track your savings progress toward specific goals")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                } else {
                    ScrollView {
                        ForEach(dataManager.goals) { goal in
                            GoalSummaryCard(goal: goal)
                        }
                    }
                }
            }
            .navigationTitle("My Piggy Bank")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddSavings = true }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.green)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Debug") {
//                        dataManager.printDebugInfo()
                    }
                }
            }
            .sheet(isPresented: $showingAddSavings) {
                AddSavingsView(isPresented: $showingAddSavings)
            }
        }
    }
}

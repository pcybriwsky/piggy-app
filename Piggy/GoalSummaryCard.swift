//
//  GoalSummaryCard.swift
//  Piggy
//
//  Created by Pedro on 1/6/25.
//


import SwiftUI

struct GoalSummaryCard: View {
    let goal: Goal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(goal.name)
                .font(.headline)
            
            ProgressView(value: goal.currentAmount, total: goal.targetAmount)
                .tint(.blue)
            
            HStack {
                Text("$\(String(format: "%.2f", goal.currentAmount))")
                Text("/")
                Text("$\(String(format: "%.2f", goal.targetAmount))")
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}
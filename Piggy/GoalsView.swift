import SwiftUI

struct GoalsView: View {
    @EnvironmentObject private var dataManager: DataManager
    @State private var showingAddGoal = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(dataManager.goals) { goal in
                    GoalRow(goal: goal)
                }
            }
            .navigationTitle("Savings Goals")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddGoal = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddGoal) {
                AddGoalView(isPresented: $showingAddGoal)
            }
        }
    }
}

struct GoalRow: View {
    let goal: Goal
    @State private var showingTransactionView = false
    
    var body: some View {
        Button(action: { showingTransactionView = true }) {
            VStack(alignment: .leading, spacing: 8) {
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
            .padding(.vertical, 4)
        }
        .sheet(isPresented: $showingTransactionView) {
            TransactionView(goal: goal)
        }
    }
}

//
//  AddSavingsView.swift
//  Piggy
//
//  Created by Pedro on 1/6/25.
//


import SwiftUI

struct AddSavingsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: DataManager
    @Binding var isPresented: Bool
    
    @State private var selectedMethod: SavingsMethod?
    @State private var customAmount = ""
    @State private var selectedGoalId: UUID?
    
    var body: some View {
        NavigationView {
            Form {
                Section("I SAVED MONEY BY...") {
                    ForEach(dataManager.savingsMethods) { method in
                        SavingsMethodButton(
                            method: method,
                            isSelected: selectedMethod?.id == method.id,
                            action: {
                                selectedMethod = method
                                customAmount = String(format: "%.2f", method.amount)
                            }
                        )
                    }
                }
                
                Section("OR ENTER A CUSTOM AMOUNT") {
                    TextField("Amount", text: $customAmount)
                        .keyboardType(.decimalPad)
                }
                
                Section("ADD TO GOAL") {
                    ForEach(dataManager.goals) { goal in
                        GoalSelectionButton(
                            goal: goal,
                            isSelected: selectedGoalId == goal.id,
                            action: { selectedGoalId = goal.id }
                        )
                    }
                }
            }
            .navigationTitle("Add Savings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { isPresented = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveTransaction()
                        isPresented = false
                    }
                    .disabled(!canSave)
                }
            }
        }
    }
    
    private var canSave: Bool {
        !customAmount.isEmpty && 
        selectedGoalId != nil && 
        selectedMethod != nil
    }
    
    private func saveTransaction() {
        guard let amount = Double(customAmount),
              let method = selectedMethod,
              let goalId = selectedGoalId else { return }
        
        dataManager.addTransaction(
            amount: amount,
            savingsMethod: method,
            goalId: goalId
        )
    }
}

// MARK: - Supporting Views
struct SavingsMethodButton: View {
    let method: SavingsMethod
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(method.name)
                Spacer()
                Text("+ $\(String(format: "%.2f", method.amount))")
                    .foregroundColor(.green)
            }
        }
        .foregroundColor(isSelected ? .blue : .primary)
    }
}

struct GoalSelectionButton: View {
    let goal: Goal
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading) {
                    Text(goal.name)
                    Text("$\(String(format: "%.2f", goal.currentAmount)) / $\(String(format: "%.2f", goal.targetAmount))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
        }
    }
}
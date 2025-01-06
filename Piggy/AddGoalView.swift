//
//  AddGoalView.swift
//  Piggy
//
//  Created by Pedro on 1/6/25.
//


import SwiftUI

struct AddGoalView: View {
    @EnvironmentObject private var dataManager: DataManager
    @Binding var isPresented: Bool
    
    @State private var name = ""
    @State private var targetAmount = ""
    @State private var deadline: Date?
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Goal Name", text: $name)
                TextField("Target Amount", text: $targetAmount)
                    .keyboardType(.decimalPad)
                
                DatePicker(
                    "Deadline (Optional)",
                    selection: Binding(
                        get: { deadline ?? Date() },
                        set: { deadline = $0 }
                    ),
                    displayedComponents: .date
                )
            }
            .navigationTitle("New Savings Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let amount = Double(targetAmount), !name.isEmpty {
                            let goal = Goal(
                                name: name,
                                targetAmount: amount,
                                deadline: deadline
                            )
                            dataManager.addGoal(goal)
                            isPresented = false
                        }
                    }
                    .disabled(name.isEmpty || targetAmount.isEmpty)
                }
            }
        }
    }
}
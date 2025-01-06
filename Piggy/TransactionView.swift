//
//  TransactionView.swift
//  Piggy
//
//  Created by Pedro on 1/6/25.
//


import SwiftUI

struct TransactionView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: DataManager
    let goal: Goal
    
    @State private var selectedMethod: SavingsMethod?
    @State private var customAmount = ""
    @State private var showingMethodPicker = false
    
    var body: some View {
        NavigationView {
            List {
                Section("Goal Progress") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("$\(String(format: "%.2f", goal.currentAmount)) saved")
                            .font(.headline)
                        
                        ProgressView(value: goal.currentAmount, total: goal.targetAmount)
                            .tint(.blue)
                        
                        Text("$\(String(format: "%.2f", goal.targetAmount)) goal")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
                
                Section("Add Savings") {
                    Button(action: { showingMethodPicker = true }) {
                        HStack {
                            Text(selectedMethod?.name ?? "Select a Way to Save")
                            Spacer()
                            if let method = selectedMethod {
                                Text("$\(String(format: "%.2f", method.amount))")
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    
                    TextField("Or enter custom amount", text: $customAmount)
                        .keyboardType(.decimalPad)
                }
                
                if !dataManager.transactions.isEmpty {
                    Section("Recent Transactions") {
                        ForEach(dataManager.transactions.filter { $0.goalId == goal.id }) { transaction in
                            TransactionRow(transaction: transaction)
                        }
                    }
                }
            }
            .navigationTitle(goal.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveTransaction()
                        dismiss()
                    }
                    .disabled(!canSave)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingMethodPicker) {
                SavingsMethodPicker(selectedMethod: $selectedMethod)
            }
        }
    }
    
    private var canSave: Bool {
        (selectedMethod != nil || !customAmount.isEmpty)
    }
    
    private func saveTransaction() {
        let amount = customAmount.isEmpty ? 
            (selectedMethod?.amount ?? 0) : 
            (Double(customAmount) ?? 0)
        
        if let method = selectedMethod {
            dataManager.addTransaction(
                amount: amount,
                savingsMethod: method,
                goalId: goal.id
            )
        }
    }
}

struct TransactionRow: View {
    let transaction: Transaction
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(transaction.savingsMethod.name)
                Text(transaction.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("$\(String(format: "%.2f", transaction.amount))")
                .foregroundColor(.green)
        }
    }
}

struct SavingsMethodPicker: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: DataManager
    @Binding var selectedMethod: SavingsMethod?
    
    var body: some View {
        NavigationView {
            List(dataManager.savingsMethods) { method in
                Button(action: {
                    selectedMethod = method
                    dismiss()
                }) {
                    HStack {
                        Text(method.name)
                        Spacer()
                        Text("$\(String(format: "%.2f", method.amount))")
                            .foregroundColor(.green)
                    }
                }
            }
            .navigationTitle("Select Way to Save")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
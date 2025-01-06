//
//  AddSavingsMethodView 2.swift
//  Piggy
//
//  Created by Pedro on 1/6/25.
//


import SwiftUI

struct AddSavingsMethodView: View {
    @EnvironmentObject private var dataManager: DataManager
    @Binding var isPresented: Bool
    
    @State private var name = ""
    @State private var amount = ""
    @State private var frequency = SavingFrequency.daily
    
    var body: some View {
        NavigationView {
            Form {
                Section("I CAN SAVE BY...") {
                    TextField("Name", text: $name)
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                    
                    Picker("How often can you save?", selection: $frequency) {
                        ForEach(SavingFrequency.allCases, id: \.self) { frequency in
                            Text(frequency.rawValue).tag(frequency)
                        }
                    }
                }
            }
            .navigationTitle("New Way to Save")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let amountDouble = Double(amount), !name.isEmpty {
                            let method = SavingsMethod(
                                name: name,
                                amount: amountDouble,
                                frequency: frequency
                            )
                            dataManager.addSavingsMethod(method)
                            isPresented = false
                        }
                    }
                    .disabled(name.isEmpty || amount.isEmpty)
                }
            }
        }
    }
}
//
//  SavingsMethodsView.swift
//  Piggy
//
//  Created by Pedro on 1/6/25.
//


import SwiftUI

struct SavingsMethodsView: View {
    @EnvironmentObject private var dataManager: DataManager
    @State private var showingAddMethod = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(dataManager.savingsMethods) { method in
                    SavingsMethodRow(method: method)
                }
                .onDelete { indexSet in
                    dataManager.removeSavingsMethod(at: indexSet)
                }
            }
            .navigationTitle("Ways to Save")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddMethod = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddMethod) {
                AddSavingsMethodView(isPresented: $showingAddMethod)
            }
        }
    }
}

struct SavingsMethodRow: View {
    let method: SavingsMethod
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(method.name)
                .font(.headline)
            HStack {
                Text("Save \(method.frequency.rawValue.lowercased())")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text("$\(String(format: "%.2f", method.amount))")
                    .font(.headline)
                    .foregroundColor(.green)
            }
        }
        .padding(.vertical, 4)
    }
}

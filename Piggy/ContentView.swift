//
//  ContentView.swift
//  Piggy
//
//  Created by Pedro on 1/3/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var dataManager = DataManager.shared
    @State private var showingAddMethod = false
    
    var body: some View {
        NavigationView {
            List {
                if dataManager.savingsMethods.isEmpty {
                    VStack {
                        Image(systemName: "piggy.bank")
                            .font(.system(size: 50))
                            .foregroundColor(.secondary)
                        Text("No Savings Methods Yet")
                            .font(.headline)
                        Text("Add ways you can save money")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowBackground(Color.clear)
                } else {
                    ForEach(dataManager.savingsMethods) { method in
                        SavingsMethodRow(method: method)
                    }
                    .onDelete { indexSet in
                        dataManager.removeSavingsMethod(at: indexSet)
                    }
                }
            }
            .navigationTitle("My Piggy Bank")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddMethod = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddMethod) {
                AddSavingsMethodView(isPresented: $showingAddMethod)
                    .environmentObject(dataManager)
            }
        }
    }
}

//struct SavingsMethodRow: View {
//    let method: SavingsMethod
//    
//    var body: some View {
//        HStack {
//            VStack(alignment: .leading) {
//                Text(method.name)
//                    .font(.custom(Theme.fontName, size: 18))
//                HStack {
//                    Text("Save")
//                        .font(.custom(Theme.fontName, size: 14))
//                        .foregroundColor(.gray)
//                    Text(method.frequency.rawValue)
//                        .font(.custom(Theme.fontName, size: 14))
//                        .foregroundColor(.gray)
//                }
//            }
//            
//            Spacer()
//            
//            Text("$\(String(format: "%.2f", method.amount))")
//                .font(.custom(Theme.fontName, size: 18))
//        }
//    }
//}

#Preview {
    ContentView()
}

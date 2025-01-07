//
//  DataManager.swift
//  Piggy
//
//  Created by Pedro on 1/6/25.
//


import SwiftUI
import Foundation
import Combine

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var savingsMethods: [SavingsMethod] = [] {
        didSet {
            print("SavingsMethods changed: \(savingsMethods.count)") // Debug
            saveData()
        }
    }
    
    @Published var goals: [Goal] = [] {
        didSet {
            print("Goals changed: \(goals.count)") // Debug
            saveData()
        }
    }
    
    @Published var transactions: [Transaction] = [] {
        didSet {
            print("Transactions changed: \(transactions.count)") // Debug
            saveData()
        }
    }
    
    private let savingsMethodsKey = "piggy_savingsMethods"  // Added prefix
    private let goalsKey = "piggy_goals"                    // Added prefix
    private let transactionsKey = "piggy_transactions"      // Added prefix
    
    private let sharedDefaults = UserDefaults(suiteName: "group.com.ngen.piggy")
    
    private init() {
        print("DataManager initializing...")
        loadData()
        setupDefaultSavingsMethods()
    }
    
    // MARK: - Savings Methods
    func addSavingsMethod(_ method: SavingsMethod) {
        savingsMethods.append(method)
        saveData()
    }
    
    func removeSavingsMethod(at indexSet: IndexSet) {
        savingsMethods.remove(atOffsets: indexSet)
        saveData()
    }
    
    // MARK: - Goals
    func addGoal(_ goal: Goal) {
        goals.append(goal)
        print("Added goal: \(goal.name), Total goals: \(goals.count)") // Debug print
        saveData()
    }
    
    // MARK: - Transactions
    func addTransaction(amount: Double, savingsMethod: SavingsMethod, goalId: UUID) {
        let transaction = Transaction(
            amount: amount,
            savingsMethod: savingsMethod,
            goalId: goalId
        )
        transactions.append(transaction)
        
        // Update goal's current amount
        if let index = goals.firstIndex(where: { $0.id == goalId }) {
            goals[index].currentAmount += amount
        }
        
        saveData()
    }
    
    // MARK: - Persistence
    private func saveData() {
        print("=== SAVING DATA ===")
        do {
            let goalsData = try JSONEncoder().encode(goals)
            UserDefaults.standard.set(goalsData, forKey: goalsKey)
            sharedDefaults?.set(goalsData, forKey: goalsKey)
            print("Successfully encoded and saved \(goals.count) goals")
            UserDefaults.standard.synchronize()
        } catch {
            print("Error saving goals: \(error)")
        }
        
        if let encoded = try? JSONEncoder().encode(savingsMethods) {
            UserDefaults.standard.set(encoded, forKey: savingsMethodsKey)
            print("Saved savings methods to UserDefaults") // Debug print
        }
        
        if let encoded = try? JSONEncoder().encode(transactions) {
            UserDefaults.standard.set(encoded, forKey: transactionsKey)
            print("Saved transactions to UserDefaults") // Debug print
        }
    }
    
    private func loadData() {
        print("=== LOADING DATA ===")
        
        if let data = UserDefaults.standard.data(forKey: goalsKey) {
            print("Found goals data in UserDefaults")
            do {
                let decoded = try JSONDecoder().decode([Goal].self, from: data)
                goals = decoded
                print("Successfully decoded \(goals.count) goals")
            } catch {
                print("Error decoding goals: \(error)")
            }
        } else {
            print("No goals data found in UserDefaults for key: \(goalsKey)")
        }
        
        if let data = UserDefaults.standard.data(forKey: savingsMethodsKey),
           let decoded = try? JSONDecoder().decode([SavingsMethod].self, from: data) {
            savingsMethods = decoded
        }
        
        if let data = UserDefaults.standard.data(forKey: transactionsKey),
           let decoded = try? JSONDecoder().decode([Transaction].self, from: data) {
            transactions = decoded
        }
    }
    
    private func setupDefaultSavingsMethods() {
        if savingsMethods.isEmpty {
            print("Setting up default savings methods...")
            let defaults = [
                SavingsMethod(name: "Skip Coffee", amount: 5.00, frequency: .daily),
                SavingsMethod(name: "Pack Lunch", amount: 15.00, frequency: .daily),
                SavingsMethod(name: "Use Public Transit", amount: 10.00, frequency: .daily),
                SavingsMethod(name: "Cancel Subscription", amount: 20.00, frequency: .monthly)
            ]
            savingsMethods = defaults
        }
    }
}
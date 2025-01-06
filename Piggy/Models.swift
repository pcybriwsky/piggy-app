//
//  SavingsMethod.swift
//  Piggy
//
//  Created by Pedro on 1/6/25.
//


import Foundation

struct SavingsMethod: Identifiable, Codable {
    var id = UUID()
    var name: String
    var amount: Double
    var frequency: SavingFrequency
    
    init(name: String, amount: Double, frequency: SavingFrequency) {
        self.name = name
        self.amount = amount
        self.frequency = frequency
    }
}

struct Goal: Identifiable, Codable {
    var id = UUID()
    var name: String
    var targetAmount: Double
    var currentAmount: Double
    var deadline: Date?
    
    init(name: String, targetAmount: Double, currentAmount: Double = 0, deadline: Date? = nil) {
        self.name = name
        self.targetAmount = targetAmount
        self.currentAmount = currentAmount
        self.deadline = deadline
    }
}

enum SavingFrequency: String, Codable, CaseIterable {
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
}

struct Transaction: Identifiable, Codable {
    var id = UUID()
    var amount: Double
    var date: Date
    var savingsMethod: SavingsMethod
    var goalId: UUID
    
    init(amount: Double, savingsMethod: SavingsMethod, goalId: UUID, date: Date = Date()) {
        self.amount = amount
        self.savingsMethod = savingsMethod
        self.goalId = goalId
        self.date = date
    }
}
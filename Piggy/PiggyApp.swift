//
//  PiggyApp.swift
//  Piggy
//
//  Created by Pedro on 1/3/25.
//

import SwiftUI

@main
struct PiggyApp: App {
    @StateObject private var dataManager = DataManager.shared
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(dataManager)
        }
    }
}

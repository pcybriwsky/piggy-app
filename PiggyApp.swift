@main
struct PiggyApp: App {
    @StateObject private var dataManager = DataManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataManager)
                .onAppear {
                    Theme.configureNavigationBarAppearance()
                }
                .onOpenURL { url in
                    handleDeepLink(url)
                }
        }
    }
    
    private func handleDeepLink(_ url: URL) {
        guard url.scheme == "piggy",
              url.host == "save",
              let methodId = UUID(uuidString: url.lastPathComponent),
              let method = dataManager.recurringExpenses.first(where: { $0.id == methodId }),
              let goal = dataManager.savingsGoals.first else {
            return
        }
        
        let transaction = SavingsTransaction(
            id: UUID(),
            date: Date(),
            amount: method.amount,
            source: method.name
        )
        
        dataManager.addTransaction(transaction, toGoal: goal.id)
    }
} 
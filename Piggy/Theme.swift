import SwiftUI
import UIKit

enum Theme {
    static let fontName = "Courier"
    static let backgroundColor = Color(.systemBackground)
    static let textColor = Color(.label)
    static let savedColor = Color(.systemGreen)
    static let expenseColor = Color(.systemRed)
    
    static func configureNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        
        if let font = UIFont(name: fontName, size: 20) {
            appearance.titleTextAttributes = [
                .font: font,
                .foregroundColor: UIColor.label
            ]
        }
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}
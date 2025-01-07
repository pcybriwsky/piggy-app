//
//  AppIntent.swift
//  PiggyWidget
//
//  Created by Pedro on 1/6/25.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")
    
    @Parameter(title: "Favorite Emoji", default: "😃")
    var favoriteEmoji: String
    
    func perform() async throws -> some IntentResult {
        return .result()
    }
}

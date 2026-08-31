import AppIntents
import UIKit
import SwiftUI

struct vnznSearchIntent: AppIntent {

    static let title: LocalizedStringResource = "Search"
    static let description: LocalizedStringResource = "Search for posts"
    static let supportedModes: IntentModes = .foreground
    
    @Parameter(title: LocalizedStringResource("Search term"))
    var searchTerm: String

    @MainActor
    func perform() async throws -> some IntentResult {
        var components = URLComponents()
        components.scheme = "vnznapp"
        components.host = "search-post"
        components.queryItems = [
            URLQueryItem(name: "q", value: searchTerm)
        ]
        
        guard let url = components.url else {
            throw CocoaError(.fileNoSuchFile)
        }
        
        EnvironmentValues().openURL(url)
        
        return .result()
    }
}

struct vnznAppShortcutsProvider: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: vnznSearchIntent(),
            phrases: [
                "Search for \(.applicationName) posts"
            ],
            shortTitle: LocalizedStringResource("Search for posts"),
            systemImageName: "magnifyingglass"
        )
    }
}

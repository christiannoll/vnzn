import AppIntents
import UIKit
import SwiftUI

struct vnznSearchIntent: AppIntent {

    static let title: LocalizedStringResource = "Search"
    static let description: LocalizedStringResource = "Search for posts"
    static var openAppWhenRun: Bool { true }

    @Parameter(title: LocalizedStringResource("Search term"))
    var searchTerm: String

    @MainActor
    func perform() async throws -> some IntentResult & OpensIntent {
        if let url = URL(string: "vnznapp://search-post?q=\(searchTerm)") {
            EnvironmentValues().openURL(url)
        }
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

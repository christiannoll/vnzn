import AppIntents
import UIKit
import SwiftUI

struct vnznSearchIntent: AppIntent {

    static var title: LocalizedStringResource = "Search"
    static let description: LocalizedStringResource = "Find a post"
    static var openAppWhenRun: Bool { true }

    @Parameter(title: "Search term")
    var searchTerm: String

    @MainActor
    func perform() async throws -> some IntentResult & OpensIntent {
        let url = URL(string: "vnznapp://search-post?q=\(searchTerm)")!
        EnvironmentValues().openURL(url)
        return .result()
    }
}

struct vnznAppShortcutsProvider: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: vnznSearchIntent(),
            phrases: [
                "Find a \(.applicationName) post"
            ],
            shortTitle: "Search for a post",
            systemImageName: "magnifyingglass"
        )
    }
}

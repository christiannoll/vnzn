import AppIntents

struct vnznSearchIntent: AppIntent {

    static var title: LocalizedStringResource = "Search"
    static let description: LocalizedStringResource = "Find a post"

    @MainActor
    func perform() async throws -> some IntentResult {
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

import Foundation
import SwiftData
import OSLog

private let logger = Logger(subsystem: "de.vnzn.vnzn", category: "AppContainer")

@MainActor
func createAppContainer() -> ModelContainer {
    do {
        guard let groupURL = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: "group.de.vnzn.vnzn")?
            .appendingPathComponent("Library/Application Support/default.store")
        else { fatalError("App Group URL not available") }

        let config = ModelConfiguration(url: groupURL)
        let container = try ModelContainer(
            for: Post.self, HistoryItem.self, Settings.self, SearchItem.self, PostsVisibility.self,
            configurations: config
        )
        container.mainContext.autosaveEnabled = false

        let languageChanged = resetIfLanguageChanged(container.mainContext)

        var settingsFetchDescriptor = FetchDescriptor<Settings>()
        settingsFetchDescriptor.fetchLimit = 1
        if try container.mainContext.fetch(settingsFetchDescriptor).isEmpty {
            let settings = Settings()
            container.mainContext.insert(settings)
        }

        var postsVisibilityFetchDescriptor = FetchDescriptor<PostsVisibility>()
        postsVisibilityFetchDescriptor.fetchLimit = 1
        if try container.mainContext.fetch(postsVisibilityFetchDescriptor).isEmpty {
            let postsVisibility = PostsVisibility()
            container.mainContext.insert(postsVisibility)
        }

        try container.mainContext.save()

        Task {
            let updateService = UpdateService()
            do {
                try await updateService.fetchUpdates(modelContext: container.mainContext, languageChanged)
            } catch {
                logger.error("fetchUpdates error: \(error)")
            }
        }

        return container
    } catch {
        fatalError("Failed to create container: \(error)")
    }
}

private func resetIfLanguageChanged(_ modelContext: ModelContext) -> Bool {
    guard let currentLanguage = Locale.currentLanguage else { return false }

    guard let savedLanguage = UserDefaults.standard.string(forKey: Locale.dataKey) else {
        UserDefaults.standard.set(currentLanguage, forKey: Locale.dataKey)
        return false
    }

    guard savedLanguage != currentLanguage else { return false }

    do {
        try modelContext.delete(model: Post.self)
        try modelContext.delete(model: HistoryItem.self)
        try modelContext.delete(model: SearchItem.self)
        UserDefaults.standard.set(currentLanguage, forKey: Locale.dataKey)
        return true
    } catch {
        logger.error("resetIfLanguageChanged: \(error.localizedDescription)")
        return false
    }
}

#if DEBUG
extension ModelContext {
    var sqliteCommand: String {
        if let url = container.configurations.first?.url.path(percentEncoded: false) {
            "sqlite3 \"\(url)\""
        } else {
            "No SQLite database found."
        }
    }
}
#endif

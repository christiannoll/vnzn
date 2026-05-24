import Foundation
import SwiftData
import OSLog

@MainActor
func createAppContainer() -> ModelContainer {
    do {
        let groupURL = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: "group.de.vnzn.vnzn")!
            .appendingPathComponent("Library/Application Support/default.store")

        let config = ModelConfiguration(url: groupURL)
        let container = try ModelContainer(
            for: Post.self, HistoryItem.self, Settings.self, SearchItem.self, PostsVisibility.self,
            configurations: config
        )
        container.mainContext.autosaveEnabled = false

        let languageChanged = resetIfLanguageChanged(container.mainContext)

        var settingsFetchDescriptor = FetchDescriptor<Settings>()
        settingsFetchDescriptor.fetchLimit = 1
        if try container.mainContext.fetch(settingsFetchDescriptor).count == 0 {
            let settings = Settings()
            container.mainContext.insert(settings)
        }

        var postsVisibilityFetchDescriptor = FetchDescriptor<PostsVisibility>()
        postsVisibilityFetchDescriptor.fetchLimit = 1
        if try container.mainContext.fetch(postsVisibilityFetchDescriptor).count == 0 {
            let postsVisibility = PostsVisibility()
            container.mainContext.insert(postsVisibility)
        }

        try container.mainContext.save()

        Task {
            let updateService = UpdateService()
            try await updateService.fetchUpdates(modelContext: container.mainContext, languageChanged)
        }

        return container
    } catch {
        fatalError("Failed to create container")
    }
}

private func resetIfLanguageChanged(_ modelContext: ModelContext) -> Bool {
    var changed = false
    do {
        if let userLanguage = UserDefaults.standard.string(forKey: Locale.dataKey) {
            if let currentLanguage = Locale.currentLanguage {
                if userLanguage != Locale.currentLanguage {
                    try modelContext.delete(model: Post.self)
                    try modelContext.delete(model: HistoryItem.self)
                    try modelContext.delete(model: SearchItem.self)
                    UserDefaults.standard.set(currentLanguage, forKey: Locale.dataKey)
                    changed = true
                }
            }
        } else {
            UserDefaults.standard.set(Locale.currentLanguage, forKey: Locale.dataKey)
        }
    } catch {
        Logger().error("\(error.localizedDescription)")
    }
    return changed
}

extension ModelContext {
    var sqliteCommand: String {
        if let url = container.configurations.first?.url.path(percentEncoded: false) {
            "sqlite3 \"\(url)\""
        } else {
            "No SQLite database found."
        }
    }
}

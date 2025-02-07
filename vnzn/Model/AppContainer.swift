import Foundation
import SwiftData

@MainActor
func createAppContainer() -> ModelContainer {
    do {
        let container = try ModelContainer(for: Post.self, HistoryItem.self, Settings.self)
        container.mainContext.autosaveEnabled = false

        Task {
            let lastUpdateKey = "lastUpdate"
            let lastUpdateFromServer = await fetchLastUpdate()
            
            
            let lastUpdateLocal = UserDefaults.standard.double(forKey: lastUpdateKey)
            if lastUpdateFromServer > lastUpdateLocal {
                let updateService = UpdateService()
                try await updateService.update(container: container)
                UserDefaults.standard.set(lastUpdateFromServer, forKey: lastUpdateKey)
            }
        }

        var settingsFetchDescriptor = FetchDescriptor<Settings>()
        settingsFetchDescriptor.fetchLimit = 1
        guard try container.mainContext.fetch(settingsFetchDescriptor).count == 0 else {
            return container
        }
        let settings = Settings()
        container.mainContext.insert(settings)

        return container
    } catch {
        fatalError("Failed to create container")
    }
}

func fetchLastUpdate() async -> Double {
    do {
        let fromUrl = VnznEnv.baseUrl + "app/last_update.txt"
        let dateString = try await Client().fetchData(fromUrl: fromUrl)
        let currentDateFormatter = DateFormatter()
        currentDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = currentDateFormatter.date(from:dateString) {
            return date.timeIntervalSince1970
        }
    } catch {
        print(error)
    }
    return 0
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

import Foundation
import SwiftData
import SwiftUI

@MainActor
final class DataProvider: Sendable {

    static let shared = DataProvider()

    init() {}

    public let sharedModelContainer: ModelContainer = {
        do {
            let container = try ModelContainer(for: Post.self, HistoryItem.self, Settings.self, SearchItem.self)
            container.mainContext.autosaveEnabled = false

            let languageChanged = resetIfLanguageChanged(container.mainContext)

            var settingsFetchDescriptor = FetchDescriptor<Settings>()
            settingsFetchDescriptor.fetchLimit = 1
            if try container.mainContext.fetch(settingsFetchDescriptor).count == 0 {
                let settings = Settings()
                container.mainContext.insert(settings)
            }

            Task {
                let updateService = UpdateService()
                //try await updateService.fetchUpdates(modelContainer: container, languageChanged)
            }

            return container
        } catch {
            fatalError("Failed to create container")
        }
    }()

    func dataHandlerCreator() -> @Sendable () async -> DataHandler {
        let container = sharedModelContainer
        return { DataHandler(modelContainer: container) }
      }

    func dataHandlerWithMainContextCreator(preview: Bool = false) -> @Sendable @MainActor () async -> DataHandler {
        let container = sharedModelContainer
        return { DataHandler(modelContainer: container, mainActor: true) }
      }

    private static func resetIfLanguageChanged(_ modelContext: ModelContext) -> Bool {
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
            print(error.localizedDescription)
        }
        return changed
    }
}

public struct DataHandlerKey: EnvironmentKey {
  public static let defaultValue: @Sendable () async -> DataHandler? = { nil }
}

extension EnvironmentValues {
  public var createDataHandler: @Sendable () async -> DataHandler? {
    get { self[DataHandlerKey.self] }
    set { self[DataHandlerKey.self] = newValue }
  }
}

public struct MainActorDataHandlerKey: EnvironmentKey {
  public static let defaultValue: @Sendable @MainActor () async -> DataHandler? = { nil }
}

extension EnvironmentValues {
  public var createDataHandlerWithMainContext: @Sendable @MainActor () async -> DataHandler? {
    get { self[MainActorDataHandlerKey.self] }
    set { self[MainActorDataHandlerKey.self] = newValue }
  }
}

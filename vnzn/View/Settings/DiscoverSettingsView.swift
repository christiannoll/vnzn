import SwiftUI
import SwiftData

struct DiscoverSettingsView: View {

    @Environment(\.dismiss) var dismiss
    @Query() var settings: [Settings]

    var body: some View {
        NavigationStack {
            Form {
                if let appSettings = settings.first {
                    @Bindable var appSettings = appSettings
                    Section("Entdecken") {
                        Toggle("Post des Tages anzeigen", isOn: $appSettings.showPostOfTheDay)
                        Toggle("Fotoserie- Gesichter anzeigen", isOn: $appSettings.showFacesPosts)
                        Toggle("Fotoserie- Poster anzeigen", isOn: $appSettings.showPosterPosts)
                        Toggle("Kurzgeschichte des Tages anzeigen", isOn: $appSettings.showShortStoryOfTheDay)
                        Toggle("Zitat des Tages anzeigen", isOn: $appSettings.showQuoteOfTheDay)
                    }
                }
            }
            .navigationTitle("Einstellungen")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Fertig") {
                        dismiss()
                    }
                }
            }
        }
    }
}

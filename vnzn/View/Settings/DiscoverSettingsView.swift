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
                            .onChange(of: appSettings.showPostOfTheDay) {
                                SwiftDataService.shared.save()
                            }
                        Toggle("Fotoserie- Gesichter anzeigen", isOn: $appSettings.showFacesPosts)
                            .onChange(of: appSettings.showFacesPosts) {
                                SwiftDataService.shared.save()
                            }
                        Toggle("Fotoserie- Poster anzeigen", isOn: $appSettings.showPosterPosts)
                            .onChange(of: appSettings.showPosterPosts) {
                                SwiftDataService.shared.save()
                            }
                        Toggle("Kurzgeschichte des Tages anzeigen", isOn: $appSettings.showShortStoryOfTheDay)
                            .onChange(of: appSettings.showShortStoryOfTheDay) {
                                SwiftDataService.shared.save()
                            }
                        Toggle("Zitat des Tages anzeigen", isOn: $appSettings.showQuoteOfTheDay)
                            .onChange(of: appSettings.showQuoteOfTheDay) {
                                SwiftDataService.shared.save()
                            }
                    }
                }
            }
            .navigationTitle("Einstellungen")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fertig") {
                        dismiss()
                    }
                }
            }
        }
    }
}

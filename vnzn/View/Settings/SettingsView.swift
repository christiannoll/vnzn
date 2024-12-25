import SwiftUI
import SwiftData

struct SettingsView: View {

    @Environment(\.dismiss) var dismiss
    @Query() var settings: [Settings]

    var body: some View {
        NavigationStack {
            Form {
                Section("Entdecken") {
                    if let appSettings = settings.first {
                        @Bindable var appSettings = appSettings
                        Toggle("Post des Tages anzeigen", isOn: $appSettings.showPostOfTheDay)
                            .onChange(of: appSettings.showPostOfTheDay) {
                                SwiftDataService.shared.save()
                            }
                        Toggle("Fotoserie- Gesichter anzeigen", isOn: $appSettings.showFacesPosts)
                            .onChange(of: appSettings.showFacesPosts) {
                                SwiftDataService.shared.save()
                            }
                    }
                }
            }
            .navigationTitle("Einstellungen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    VStack {
                        Button {
                            dismiss()
                        } label: {
                            Text("Fertig")
                                .foregroundStyle(Color.accentColor)
                        }
                        Spacer()
                    }
                    .padding(.trailing, 16)
                }
            }
        }
    }
}

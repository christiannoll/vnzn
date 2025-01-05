import SwiftUI
import SwiftData

struct SettingsView: View {

    @Environment(\.dismiss) var dismiss
    @Environment(Router.self) var router: Router
    @Query() var settings: [Settings]

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.settingsViewNavigationPath) {
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
                    }
                    Section("App") {
                        List {
                            Button {
                                router.settingsViewNavigationPath.append(NavigationTarget.appInfo)
                            } label: {
                                HStack {
                                    Image(systemName: "info.circle")
                                        .foregroundStyle(Color.accentColor)
                                    Text("Über die App")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.secondary)
                                }
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .selectNavigationDestination()
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

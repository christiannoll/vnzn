import SwiftUI
import SwiftData
import NotificationCenter

struct SettingsView: View {

    @Environment(\.dismiss) var dismiss
    @Environment(Router.self) var router: Router
    @Query() var settings: [Settings]

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.currentNavigationPath) {
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
                    Section("App") {
                        List {
                            Button {
                                router.currentNavigationPath.append(NavigationTarget.appInfo)
                            } label: {
                                HStack {
                                    Image(systemName: "info.circle")
                                    Text("Über die App")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.tertiary)
                                }
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                            Button {
                                Task {
                                    await openNotificationSettings()
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "bell.badge")
                                    Text("Mitteilungen")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.tertiary)
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
                    Button("Fertig") {
                        dismiss()
                    }
                }
            }
        }
    }

    func openNotificationSettings() async {
        let center = UNUserNotificationCenter.current()

        await center.getNotificationSettingsAndHandle()
    }
}

private extension UNUserNotificationCenter {
    func getNotificationSettingsAndHandle() async {
        let settings = await self.notificationSettings()

        if case .notDetermined = settings.authorizationStatus {
            do {
                _ = try await self.requestAuthorization(options: [.badge, .sound, .alert])
            } catch {
                print("Authorization request failed: \(error)")
            }
        } else {
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if await UIApplication.shared.canOpenURL(settingsUrl) {
                await UIApplication.shared.open(settingsUrl, completionHandler: { _ in })
            }
        }
    }
}

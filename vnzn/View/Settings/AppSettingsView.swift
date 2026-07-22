import SwiftUI
import SwiftData
import NotificationCenter
import OSLog

struct AppSettingsView: View {

    @Environment(\.dismiss) var dismiss
    @Environment(Router.self) var router: Router
    @Query() var settings: [Settings]

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.currentNavigationPath) {
            Form {
                if let appSettings = settings.first {
                    @Bindable var appSettings = appSettings
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
                Section("Design") {
                    AppearancePicker()
                }
            }
            .selectNavigationDestination()
            .navigationTitle("Einstellungen")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Fertig", systemImage: "xmark") {
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
        let logger = Logger(subsystem: "de.vnzn.vnzn", category: "UNUserNotificationCenter")

        if case .notDetermined = settings.authorizationStatus {
            do {
                _ = try await self.requestAuthorization(options: [.badge, .sound, .alert])
            } catch {
                logger.error("Authorization request failed: \(error)")
            }
        } else {
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            UIApplication.shared.open(settingsUrl, options: [:]) { success in
                if !success {
                    logger.error("Failed to open settings app")
                }
            }
        }
    }
}

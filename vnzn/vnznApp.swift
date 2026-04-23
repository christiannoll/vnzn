import SwiftUI
import SwiftData
import BackgroundTasks

@main
struct vnznApp: App {

    private var router = Router()
    private var siteStatistics = SiteStatistics()
    private var metaData = MetaData()
    private var modelContainer = createAppContainer()

    @Environment(\.scenePhase) private var scenePhase
    @AppStorage("appearance") private var appearance: Appearance = .system

    private static let appRefreshIdentifier = "de.vnzn.vnzn.scheduler"

    init() {
        SwiftDataService.shared.setup(modelContext: modelContainer.mainContext)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(router)
                .environment(metaData)
                .environment(siteStatistics)
                .preferredColorScheme(appearance.colorScheme)
                .onOpenURL { url in
                    router.navigate(to: url)
                }
        }
        .modelContainer(modelContainer)
        .onChange(of: scenePhase) { _, newPhase in
            switch newPhase {
            case .background:
                SwiftDataService.shared.save()
                scheduleAppRefreshTask()
            default:
                break
            }
        }

        .backgroundTask(.appRefresh(Self.appRefreshIdentifier)) {
            await handleAppRefresh()
        }
    }

    private func handleAppRefresh() async {
        scheduleAppRefreshTask()

        guard await UserNotificationController.shared.areNotificationsAuthorized() else {
            print("[BGTask] Notifications not authorized")
            return
        }

        let hasNewItems = await newItemsAvailable()

        if hasNewItems {
            await UserNotificationController.shared.sendNotification(
                message: String(localized: "Neue Posts verfügbar!"),
                title: "vnzn.app",
                sound: true
            )
            print("[BGTask] Notification sent")
        } else {
            print("[BGTask] No new items")
        }
    }

    private func scheduleAppRefreshTask() {
        let request = BGAppRefreshTaskRequest(identifier: Self.appRefreshIdentifier)
        request.earliestBeginDate = Date().addingTimeInterval(15 * 60)

        do {
            try BGTaskScheduler.shared.submit(request)
            print("[BGTaskScheduler] scheduled:", request.earliestBeginDate ?? Date())
        } catch {
            print("[BGTaskScheduler] scheduling error:", error)
        }
    }

    private func newItemsAvailable() async -> Bool {
        let lastUpdateFromServer: Double = await withTaskGroup(of: Double?.self) { group in
            group.addTask { await Client.shared.fetchLastUpdate() }
                group.addTask {
                    try? await Task.sleep(nanoseconds: 20_000_000_000)
                    return nil // Timeout → nil
                }

                let result = await group.next() ?? nil
                group.cancelAll()
                return result ?? 0
            }

        let lastUpdateLocal = UserDefaults.standard.double(forKey: UpdateService.lastUpdateKey)
        return lastUpdateFromServer > lastUpdateLocal
    }
}

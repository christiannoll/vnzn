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
                .onOpenURL { url in
                    router.navigate(to: url)
                }
        }
        .modelContainer(modelContainer)
        .onChange(of: scenePhase) {
            switch scenePhase {
            case .background:
                Task {
                    if await UserNotificationController.shared.areNotificationsAuthorized() {
                        scheduleAppRefreshTask()
                    }
                }
            default:
                break
            }
        }
        .backgroundTask(.appRefresh(Self.appRefreshIdentifier)) {
            if await newItemsAvailable() {
                await UserNotificationController.shared.sendNotification(message: "Neue Posts verfügbar!", title: "Background task", sound: true)
            }
        }
    }

    private func scheduleAppRefreshTask() {
        let request = BGAppRefreshTaskRequest(identifier: Self.appRefreshIdentifier)
        request.earliestBeginDate = .now.addingTimeInterval(5)//(24 * 3600)
        do {
            try BGTaskScheduler.shared.submit(request)
            print("[BGTaskScheduler] submitted task with id: \(request.identifier)")
        } catch {
            print("[BGTaskScheduler] error:", error)
        }
    }

    private func newItemsAvailable() async -> Bool {
        let lastUpdateFromServer = await fetchLastUpdate()

        let lastUpdateLocal = UserDefaults.standard.double(forKey: UpdateService.lastUpdateKey)
        return lastUpdateFromServer > lastUpdateLocal
    }
}

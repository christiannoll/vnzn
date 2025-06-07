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
                scheduleAppRefreshTask()
            default:
                break
            }
        }
        .backgroundTask(.appRefresh(Self.appRefreshIdentifier)) {
            // TODO: do something when the task is invoked
        }
    }

    private func scheduleAppRefreshTask() {
        let request = BGAppRefreshTaskRequest(identifier: Self.appRefreshIdentifier)
        request.earliestBeginDate = .now.addingTimeInterval(24 * 3600)
        do {
            try BGTaskScheduler.shared.submit(request)
            print("[BGTaskScheduler] submitted task with id: \(request.identifier)")
        } catch {
            print("[BGTaskScheduler] error:", error)
        }
    }
}

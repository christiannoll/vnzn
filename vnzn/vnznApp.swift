import SwiftUI
import SwiftData

@main
struct vnznApp: App {
    
    private var router = Router()
    private var siteStatistics = SiteStatistics()
    private var metaData = MetaData()
    private var modelContainer = createAppContainer()
    
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
    }
}

import SwiftUI
import SwiftData

@main
struct vnznApp: App {
    
    private var router = Router()
    private var siteStatistics = SiteStatistics()
    private var metaData = MetaData()
    //private var modelContainer = createAppContainer()

    let dataProvider = DataProvider.shared

    init() {
        //SwiftDataService.shared.setup(modelContext: modelContainer.mainContext)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.createDataHandler, dataProvider.dataHandlerCreator())
                .environment(\.createDataHandlerWithMainContext, dataProvider.dataHandlerWithMainContextCreator())
                .environment(router)
                .environment(metaData)
                .environment(siteStatistics)
                .onOpenURL { url in
                    router.navigate(to: url)
                }
        }
        .modelContainer(dataProvider.sharedModelContainer)
    }
}

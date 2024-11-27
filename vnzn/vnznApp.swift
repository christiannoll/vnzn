import SwiftUI
import SwiftData

@main
struct vnznApp: App {
    
    private var router = Router()
    private var index = Index()
    private var tags = Tags()
    private var modelContainer = createAppContainer()
    
    init() {
        SwiftDataService.shared.setup(modelContext: modelContainer.mainContext)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(router)
                .environment(index)
                .environment(tags)
        }
        .modelContainer(modelContainer)
    }
}

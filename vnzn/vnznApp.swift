import SwiftUI
import SwiftData

@main
struct vnznApp: App {
    
    private var router = Router()
    private var index = Index()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(router)
                .environment(index)
        }
        .modelContainer(appContainer)
    }
}

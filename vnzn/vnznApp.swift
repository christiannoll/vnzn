import SwiftUI
import SwiftData

@main
struct vnznApp: App {
    
    @State private var router = Router()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(router)
        }
        .modelContainer(appContainer)
    }
}

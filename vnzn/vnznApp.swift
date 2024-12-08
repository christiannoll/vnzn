import SwiftUI
import SwiftData

@main
struct vnznApp: App {
    
    private var router = Router()
    private var index = Index()
    private var tags = Tags()
    private var serials = Serials()
    private var archive = Archive()
    private var siteStatistics = SiteStatistics()
    private var timeline = Timeline()
    private var persons = PersonsRegister()
    private var movies = MoviesRegister()
    private var books = BooksRegister()
    private var indices = IndexRegister()
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
                .environment(serials)
                .environment(archive)
                .environment(siteStatistics)
                .environment(timeline)
                .environment(persons)
                .environment(movies)
                .environment(books)
                .environment(indices)
        }
        .modelContainer(modelContainer)
    }
}

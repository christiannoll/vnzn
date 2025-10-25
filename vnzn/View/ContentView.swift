import SwiftUI

struct ContentView: View {
    
    @Environment(Router.self) var router: Router

    var body: some View {
        @Bindable var router = router
        TabView(selection: $router.selectedTab) {
            Tab("Blog", systemImage: "rectangle.stack", value: .posts) {
                PostsView()
            }
            Tab("Entdecken", systemImage: "globe", value: .discover) {
                DiscoverView()
            }
            /*Tab("Index", systemImage: "list.bullet", value: .index) {
                IndexView()
            }*/
            Tab("Verlauf", systemImage: "clock", value: .history) {
                HistoryView()
            }
            Tab("Meta", systemImage: "ellipsis.circle", value: .meta) {
                MetaView()
            }
            Tab(value: .search, role: .search) {
                SearchView()
            }
        }
    }
}

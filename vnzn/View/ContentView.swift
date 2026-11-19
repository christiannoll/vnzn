import SwiftUI

struct ContentView: View {
    
    @Environment(Router.self) var router: Router

    var body: some View {
        @Bindable var router = router
        TabView(selection: $router.selectedTab) {
            Tab("Blog", systemImage: "rectangle.stack", value: .posts) {
                PostsDuoView()
            }
            Tab("Entdecken", systemImage: "globe", value: .discover) {
                DiscoverView()
            }
            Tab("Verlauf", systemImage: "clock", value: .history) {
                HistoryView()
            }
            Tab("Meta", systemImage: "ellipsis.circle", value: .meta) {
                MetaDuoView()
            }
            Tab(value: .search, role: .search) {
                SearchView()
            }
        }
    }
}

struct PostsDuoView: View {
    var body: some View {
        ArrangementView {
            PostsView()
        } secondary: {
            SearchView()
                .splitArrangementLayoutRatio(0.45)
        }
        .arrangementViewStyle(.split.axes(.horizontal))
    }
}

struct MetaDuoView: View {
    var body: some View {
        ArrangementView {
            MetaView()
        } secondary: {
            SearchView()
                .splitArrangementLayoutRatio(0.45)
        }
        .arrangementViewStyle(.split.axes(.horizontal))
    }
}

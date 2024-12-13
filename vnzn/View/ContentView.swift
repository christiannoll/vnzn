import SwiftUI

struct ContentView: View {
    
    @Environment(Router.self) var router: Router

    var body: some View {
        @Bindable var router = router
        TabView(selection: $router.selectedTab) {
            PostsView()
                .tabItem {
                    if router.selectedTab == .posts {
                        Label("Blog", systemImage: "rectangle.stack.fill")
                    } else {
                        Label("Blog", systemImage: "rectangle.stack")
                    }
                }
                .tag(Router.Tabs.posts)
            DiscoverView()
                .tabItem {
                    if router.selectedTab == .discover {
                        Label("Entdecken", systemImage: "globe")
                            .foregroundStyle(Color.accentColor)
                    } else {
                        Label("Entdecken", systemImage: "globe")
                    }
                }
                .tag(Router.Tabs.discover)
            IndexView()
                .tabItem {
                    if router.selectedTab == .index {
                        Label("Index", systemImage: "list.bullet")
                            .foregroundStyle(Color.accentColor)
                    } else {
                        Label("Index", systemImage: "list.bullet")
                    }
                }
                .tag(Router.Tabs.index)
            HistoryView()
                .tabItem {
                    if router.selectedTab == .history {
                        Label("Verlauf", systemImage: "clock.fill")
                    } else {
                        Label("Verlauf", systemImage: "clock")
                    }
                }
                .tag(Router.Tabs.history)
            MetaView()
                .tabItem {
                    if router.selectedTab == .meta {
                        Label("Meta", systemImage: "ellipsis.circle.fill")
                    } else {
                        Label("Meta", systemImage: "ellipsis.circle")
                    }
                }
                .tag(Router.Tabs.meta)
        }
    }
}

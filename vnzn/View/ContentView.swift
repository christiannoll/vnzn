import SwiftUI

struct ContentView: View {
    
    @Environment(Router.self) var router: Router

    var body: some View {
        @Bindable var router = router
        TabView(selection: $router.selectedTab) {
            TimelineView()
                .tabItem {
                    if router.selectedTab == .timeline {
                        Label("Timeline", systemImage: "rectangle.stack.fill")
                    } else {
                        Label("Timeline", systemImage: "rectangle.stack")
                    }
                }
                .tag(Router.Tabs.timeline)
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
            TagsView()
                .tabItem {
                    if router.selectedTab == .tags {
                        Label("Kategorien", systemImage: "tag.fill")
                    } else {
                        Label("Kategorien", systemImage: "tag")
                    }
                }
                .tag(Router.Tabs.tags)
            HistoryView()
                .tabItem {
                    if router.selectedTab == .history {
                        Label("Verlauf", systemImage: "clock.fill")
                    } else {
                        Label("Verlauf", systemImage: "clock")
                    }
                }
                .tag(Router.Tabs.history)
        }
    }
}

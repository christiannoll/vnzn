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
            FavouritesView()
                .tabItem {
                    if router.selectedTab == .favourites {
                        Label("Favourites", systemImage: "star.fill")
                    } else {
                        Label("Favourites", systemImage: "star")
                    }
                }
                .tag(Router.Tabs.favourites)
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
        }
    }
}

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
            .tag(Router.Tabs.timeline)        }
    }
}

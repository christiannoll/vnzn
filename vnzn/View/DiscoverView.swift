import SwiftUI
import SwiftData

struct DiscoverView: View {

    @Query(sort: \Post.date) var posts: [Post]
    @Query() var settings: [Settings]
    @Environment(Serials.self) var serials: Serials
    @Environment(Router.self) var router: Router

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.discoverViewNavigationPath) {
            List {
                if postOfTheDayVisible() {
                    Section("Post des Tages") {
                        PostOfTheDay(posts: posts)
                    }
                    .listRowSeparator(.hidden)
                }
                if facesPostsVisible() {
                    Section("Fotoserie: Gesichter") {
                        FacesPosts(posts: posts)
                    }
                    .listRowSeparator(.hidden)
                }
            }
            .environment(\.defaultMinListHeaderHeight, 0)
            .selectNavigationDestination()
            .navigationTitle("Entdecken")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .tabBar)
        }
    }

    private func postOfTheDayVisible() -> Bool {
        if let appSettings = settings.first {
            return appSettings.showPostOfTheDay
        }
        return true
    }

    private func facesPostsVisible() -> Bool {
        if let appSettings = settings.first {
            return appSettings.showFacesPosts
        }
        return true
    }
}

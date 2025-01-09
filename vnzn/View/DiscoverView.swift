import SwiftUI
import SwiftData

struct DiscoverView: View {

    @Query(sort: \Post.date) var posts: [Post]
    @Query() var settings: [Settings]

    @Environment(Router.self) var router: Router

    @State private var urlToOpen: URL?
    @State private var isSafariPresented = false

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.discoverViewNavigationPath) {
            List {
                if postOfTheDayVisible() {
                    Section("Post des Tages") {
                        PostOfTheDay(posts: posts, urlToOpen: $urlToOpen, isSafariPresented: $isSafariPresented)
                    }
                    .listRowSeparator(.hidden)
                }
                if facesPostsVisible() {
                    Section("Fotoserie: Gesichter") {
                        PhotoPosts(posts: posts, dataKey: "facesPosts", tagItemKey: "Fotos: Gesichter")
                    }
                    .listRowSeparator(.hidden)
                }
                if posterPostsVisible() {
                    Section("Fotoserie: Poster") {
                        PhotoPosts(posts: posts, dataKey: "posterPosts", tagItemKey: "Fotos: Poster")
                    }
                    .listRowSeparator(.hidden)
                }
            }
            .background(alignment: .trailing) {
                if let urlToOpen {
                    SafariViewControllerPresenter(url: urlToOpen, isPresented: $isSafariPresented)
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

    private func posterPostsVisible() -> Bool {
        if let appSettings = settings.first {
            return appSettings.showPosterPosts
        }
        return true
    }
}

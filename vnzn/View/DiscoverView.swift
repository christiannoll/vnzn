import SwiftUI
import SwiftData

struct DiscoverView: View {

    @Query(sort: \Post.date) var posts: [Post]
    @Query() var settings: [Settings]

    @Environment(Router.self) var router: Router
    @Environment(MetaData.self) var metaData: MetaData

    @State private var urlToOpen: URL?
    @State private var isSafariPresented = false
    @State private var settingsVisible = false

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.discoverViewNavigationPath) {
            List {
                if posts.isEmpty == false {
                    if postOfTheDayVisible() {
                        Section("Post des Tages") {
                            PostOfTheDay(posts: posts, urlToOpen: $urlToOpen,
                                         isSafariPresented: $isSafariPresented,
                                         dataKey: "postOfTheDay")
                        }
                        .listRowSeparator(.hidden)
                    }
                    if facesPostsVisible() {
                        Section("Fotoserie: Gesichter") {
                            PhotoPosts(posts: posts, dataKey: "facesPosts", tagItemKey: facesTagItemKey)
                        }
                        .listRowSeparator(.hidden)
                    }
                    if posterPostsVisible() {
                        Section("Fotoserie: Poster") {
                            PhotoPosts(posts: posts, dataKey: "posterPosts", tagItemKey: posterTagItemKey)
                        }
                        .listRowSeparator(.hidden)
                    }
                    if shortStoryOfTheDayVisible() {
                        Section("Kurzgeschichte des Tages") {
                            PostOfTheDay(posts: shortStories, urlToOpen: $urlToOpen,
                                         isSafariPresented: $isSafariPresented,
                                         dataKey: "shortStoryOfTheDay")
                        }
                        .listRowSeparator(.hidden)
                    }
                    if quoteOfTheDayVisible() {
                        Section("Zitat des Tages") {
                            PostOfTheDay(posts: quotes, urlToOpen: $urlToOpen,
                                         isSafariPresented: $isSafariPresented,
                                         dataKey: "quoteOfTheDay")
                        }
                        .listRowSeparator(.hidden)
                    }
                }
            }
            .task {
                if metaData.tags.tagItems.isEmpty {
                    await metaData.tags.createTags(posts)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        settingsVisible.toggle()
                    } label: {
                        Image(systemName: "gearshape")
                            .foregroundStyle(Color.accentColor)
                    }
                    .padding(.trailing, 16)
                }
            }
            .background(alignment: .trailing) {
                if let urlToOpen {
                    SafariViewControllerPresenter(url: urlToOpen, isPresented: $isSafariPresented)
                }
            }
            .sheet(isPresented: $settingsVisible) {
                SettingsView()
            }
            .environment(\.defaultMinListHeaderHeight, 0)
            .selectNavigationDestination()
            .navigationTitle("Entdecken")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .tabBar)
        }
    }

    private var facesTagItemKey: String {
        Locale.isEnglish ? "Photos: Faces" : "Fotos: Gesichter"
    }

    private var posterTagItemKey: String {
        Locale.isEnglish ? "Photos: Poster" : "Fotos: Poster"
    }

    private var quoteTagItemKey: String {
        Locale.isEnglish ? "Quote" : "Zitat"
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

    private func shortStoryOfTheDayVisible() -> Bool {
        if let appSettings = settings.first {
            return appSettings.showShortStoryOfTheDay
        }
        return true
    }

    private func quoteOfTheDayVisible() -> Bool {
        if let appSettings = settings.first {
            return appSettings.showQuoteOfTheDay
        }
        return true
    }

    private var shortStories: [Post] {
        if let tagItem = metaData.tags.getTagItem("Short Story") {
            return tagItem.posts
        }
        return []
    }

    private var quotes: [Post] {
        if let index = metaData.index.getIndexItem(quoteTagItemKey) {
            return index.posts
        }
        return []
    }
}

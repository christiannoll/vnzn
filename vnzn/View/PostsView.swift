import SwiftUI
import SwiftData

struct PostsView: View {

    @StateObject private var viewModel = PostsViewModel()

    @State private var settingsVisible = false
    @State private var isLoading = true

    @Environment(MetaData.self) var metaData: MetaData
    @Environment(Router.self) var router: Router
    @Environment(NotificationHandler.self) var notificationHandler: NotificationHandler

    @AppStorage("appearance") private var appearance: Appearance = .system
    @Environment(\.colorScheme) private var systemColorScheme
    @Environment(\.horizontalSizeClass) private var sizeClass

    @Query() var postsVisibilities: [PostsVisibility]
    var postsVisibility: PostsVisibility? {
        postsVisibilities.first
    }

    var body: some View {
        @Bindable var router = router

        Group {
            if sizeClass == .regular {
                // iPad / breites Fenster: Sidebar + Detail
                NavigationSplitView {
                    postsList
                        .environment(\.replacesDetail, true)
                        .navigationSplitViewColumnWidth(min: 340, ideal: 400, max: 500)
                } detail: {
                    NavigationStack(path: $router.postsViewNavigationPath) {
                        ContentUnavailableView("Kein Post ausgewählt", systemImage: "doc.text")
                            .selectNavigationDestination()
                    }
                }
            } else {
                // iPhone / schmales Fenster: wie bisher
                NavigationStack(path: $router.postsViewNavigationPath) {
                    postsList
                        .selectNavigationDestination()
                }
            }
        }
        .onChange(of: notificationHandler.newItemsAvailable) {
            if notificationHandler.newItemsAvailable {
                refreshItems()
            }
            notificationHandler.newItemsAvailable = false
        }
        .sheet(isPresented: $settingsVisible) {
            AppSettingsView()
                .preferredColorScheme(appearance.resolved(with: systemColorScheme))
        }
        .onReceive(NotificationCenter.publisher(for: .fetchPosts)) { _ in
            viewModel.fetchPosts()
            initMetaData()
            isLoading = false
        }
    }

    // MARK: - Liste

    private var postsList: some View {
        let posts = visiblePosts
        return List {
            if isLoading {
                LoadingView()
                    .listRowBackground(Color.clear)
            }
            if posts.isEmpty && showOnlyFavourites {
                Text("Keinen passenden Post gefunden. 🙁")
            }
            ForEach(posts) { post in
                PostRow(post: post, posts: posts, action: {})
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("\(post.title), \(Date.createPostDate(post))")
                    .accessibilityHint("Doppeltippen zum Anzeigen des Blogeintrags")
                    .accessibilityAddTraits(.isButton)
            }
        }
        .scrollContentBackground(.hidden)
        .navigationTitle("v.n.z.n")
        .refreshable {
            refreshItems()
        }
        .toolbar {
            PostsVisibilityView()
            ToolbarItem(placement: .topBarTrailing) {
                Button("settings", systemImage: "gearshape") {
                    settingsVisible.toggle()
                }
            }
        }
        .toolbarBackground(.visible, for: .tabBar)
    }

    // MARK: - Daten

    private var visiblePosts: [Post] {
        let sorted: [Post] = (postsVisibility?.oldestFirst ?? false)
            ? Array(viewModel.filteredItems.reversed())
            : viewModel.filteredItems
        return slice(items: sorted.filter { shouldInclude($0) })
    }

    private var showOnlyFavourites: Bool {
        postsVisibility?.onlyFavourites ?? false
    }

    private func refreshItems() {
        Task {
            let updateService = UpdateService()
            try? await updateService.fetchUpdates(modelContext: SwiftDataService.shared.context)
        }
    }

    private func shouldInclude(_ post: Post) -> Bool {
        if let postsVisibility {
            if postsVisibility.onlyFavourites && !post.isFavourite {
                return false
            }
        }
        return true
    }

    private func initMetaData() {
        Task {
            if metaData.tags.tagItems.isEmpty {
                await metaData.tags.createTags(viewModel.posts)
            }
            if metaData.index.indexItems.isEmpty {
                await metaData.index.createIndex(viewModel.posts)
            }
            if metaData.serials.tagItems.isEmpty {
                await metaData.serials.createSerials(viewModel.posts)
            }
        }
    }

    private func slice(items: [Post]) -> [Post] {
        if let postsVisibility {
            switch postsVisibility.postsLimit {
            case .all:
                return items
            case .ten:
                return Array(items.prefix(10))
            case .twenty:
                return Array(items.prefix(20))
            case .fifty:
                return Array(items.prefix(50))
            }
        }
        return items
    }
}


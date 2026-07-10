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

    @Query() var postsVisibilities: [PostsVisibility]
    var postsVisibility: PostsVisibility? {
        postsVisibilities.first
    }

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.postsViewNavigationPath) {
            List {
                if isLoading {
                    LoadingView()
                        .listRowBackground(Color.clear)
                }
                let sortedItems = postsVisibility?.oldestFirst ?? false ? viewModel.filteredItems.reversed() : viewModel.filteredItems
                let filteredItems = sortedItems.filter { shouldInclude($0) }
                if filteredItems.isEmpty {
                    Text("Keinen passenden Post gefunden. 🙁")
                }
                let slicedItems = slice(items: filteredItems)
                ForEach (slicedItems) { post in
                    PostRow(post: post, posts: slicedItems, action: {})
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("\(post.title), \(Date.createPostDate(post))")
                        .accessibilityHint("Doppeltippen zum Anzeigen des Blogeintrags")
                        .accessibilityAddTraits(.isButton)
                }
            }
            .selectNavigationDestination()
            .scrollContentBackground(.hidden)
            .navigationTitle("v.n.z.n")
            .refreshable {
                refreshItems()
            }
            .onChange(of: notificationHandler.newItemsAvailable) {
                if notificationHandler.newItemsAvailable {
                    refreshItems()
                }
                notificationHandler.newItemsAvailable = false
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

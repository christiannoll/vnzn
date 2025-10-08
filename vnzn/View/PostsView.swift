import SwiftUI

struct PostsView: View {

    @StateObject private var viewModel = PostsViewModel()

    @State private var onlyFavourites = false
    @State private var settingsVisible = false
    @State private var isLoading = true

    @Environment(MetaData.self) var metaData: MetaData
    @Environment(Router.self) var router: Router

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.postsViewNavigationPath) {
            List {
                if isLoading {
                    LoadingView()
                }
                let filteredItems = viewModel.filteredItems.filter { shouldInclude($0) }
                ForEach (filteredItems) { post in
                    PostRow(post: post, posts: filteredItems)
                }
            }
            .selectNavigationDestination()
            .searchable(text: $viewModel.searchText, prompt: "vnzn durchsuchen")
            .scrollContentBackground(.hidden)
            .navigationTitle("v.n.z.n")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarTitleTextColor(.blue)
            .refreshable {
                Task {
                    let updateService = UpdateService()
                    try await updateService.fetchUpdates(modelContext: SwiftDataService.shared.context)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("favourites", systemImage: onlyFavourites ? "star.fill" : "star") {
                        onlyFavourites.toggle()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("settings", systemImage: "gearshape") {
                        settingsVisible.toggle()
                    }
                }
            }
            .toolbarBackground(.visible, for: .tabBar)
            .sheet(isPresented: $settingsVisible) {
                SettingsView()
            }
            .onReceive(NotificationCenter.publisher(for: .fetchPosts)) { _ in
                //isLoading = true
                viewModel.fetchPosts()
                initMetaData()
                isLoading = false
            }
        }
    }
    
    private func shouldInclude(_ post: Post) -> Bool {
        if onlyFavourites && !post.isFavourite {
            return false
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
}

extension View {
    @available(iOS 14, *)
    func navigationBarTitleTextColor(_ color: Color) -> some View {
        let uiColor = UIColor(color)
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor ]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor ]
        return self
    }
}

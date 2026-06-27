import SwiftUI
import SwiftData

struct SearchView: View {

    @StateObject private var viewModel = PostsViewModel()

    @Environment(MetaData.self) var metaData: MetaData
    @Environment(Router.self) var router: Router

    @State private var dataRetrieved = false

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.searchViewNavigationPath) {
            SearchScrollView()
                .environmentObject(viewModel)
                .selectNavigationDestination()
                .searchable(text: $viewModel.searchText,
                            placement: .navigationBarDrawer(displayMode: .always),
                            prompt: "vnzn durchsuchen")
                .scrollContentBackground(.hidden)
                .navigationTitle("Suchen")
                .task {
                    if dataRetrieved == false {
                        viewModel.fetchPosts()
                        await initMetaData()
                        dataRetrieved = true
                    }
                }
        }
    }

    private func initMetaData() async {
        if metaData.tags.tagItems.isEmpty {
            await metaData.tags.createTags(viewModel.posts)
        }
    }
}

struct SearchScrollView: View {

    @EnvironmentObject var viewModel: PostsViewModel
    @Environment(MetaData.self) var metaData: MetaData
    @Environment(\.isSearching) private var isSearching

    var body: some View {
        ScrollView {
            if isSearching {
                LazyVGrid(columns: [GridItem(.flexible())]) {
                    if viewModel.searchText.isEmpty {
                        SearchHistoryView()
                            .environmentObject(viewModel)
                    } else {
                        let filteredItems = viewModel.filteredItems
                        ForEach (filteredItems) { post in
                            PostRow(post: post, posts: filteredItems, action: { SwiftDataService.shared.saveSearchItem(searchTerm: viewModel.searchText, post: post)
                            })
                        }
                    }
                }
                .padding()
            } else {
                TagsGridView(tagItems: metaData.tags.tagItems)
                .padding()
            }
        }
    }
}

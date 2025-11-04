import SwiftUI
import SwiftData

struct SearchView: View {

    @StateObject private var viewModel = PostsViewModel()

    @Environment(MetaData.self) var metaData: MetaData
    @Environment(Router.self) var router: Router

    @FocusState private var isSearchFieldFocused: Bool

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.searchViewNavigationPath) {
            ScrollView {
                if isSearchFieldFocused || !viewModel.searchText.isEmpty {
                    LazyVGrid(columns: [GridItem(.flexible())]) {
                        if viewModel.searchText.isEmpty {
                            SearchHistoryView()
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
            .selectNavigationDestination()
            .searchable(text: $viewModel.searchText, prompt: "vnzn durchsuchen")
            .scrollContentBackground(.hidden)
            .navigationTitle("Suchen")
            .searchFocused($isSearchFieldFocused)
            .task {
                viewModel.fetchPosts()
                await initMetaData()
            }
        }
    }

    private func initMetaData() async {
        if metaData.tags.tagItems.isEmpty {
            await metaData.tags.createTags(viewModel.posts)
        }
    }
}

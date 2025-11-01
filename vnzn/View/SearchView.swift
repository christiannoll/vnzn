import SwiftUI
import SwiftData

struct SearchView: View {

    @StateObject private var viewModel = PostsViewModel()

    @Environment(MetaData.self) var metaData: MetaData
    @Environment(Router.self) var router: Router
    @Environment(\.modelContext) private var modelContext

    @FocusState private var isSearchFieldFocused: Bool

    @Query(sort: \Post.date) var posts: [Post]
    @Query(sort: \SearchItem.date, order: .reverse) var searchItems: [SearchItem]

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.searchViewNavigationPath) {
            ScrollView {
                if isSearchFieldFocused || !viewModel.searchText.isEmpty {
                    LazyVGrid(columns: [GridItem(.flexible())]) {
                        if viewModel.searchText.isEmpty {
                            HStack {
                                Text("Zuletzt gesucht")
                                    .font(.subheadline)
                                    .bold()
                                    .padding(4)
                                Spacer()
                                Button("Löschen") {
                                    deleteSearchHistory()
                                }
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                                .bold()
                                .padding(4)
                            }
                            ForEach (searchItems) { searchItem in
                                Divider()
                                    .padding(.vertical, 4)
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(searchItem.post.title)
                                            .bold()
                                        Spacer()
                                    }
                                    Text(Date.createPostDate(searchItem.post)).foregroundStyle(.secondary).font(.footnote)
                                }
                                .onTapGesture {
                                    router.currentNavigationPath.append(NavigationTarget.post(searchItem.post, posts))
                                }
                            }
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
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(minimum: 50, maximum: .infinity)),
                            GridItem(.flexible(minimum: 50, maximum: .infinity))
                        ],
                        alignment: .leading,
                        spacing: 10
                    ) {
                        ForEach (metaData.tags.tagItems) { tagItem in
                            Button {
                                router.currentNavigationPath.append(NavigationTarget.tag(tagItem))
                            } label: {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Spacer()
                                        Image(systemName: "star")
                                            .padding(.horizontal)
                                            .foregroundStyle(.background)
                                    }
                                    Text(tagItem.tagTitle)
                                        .bold()
                                        .padding(.horizontal)
                                        .padding(.top, 4)
                                        .foregroundColor(.white)
                                }
                                .frame(height: 70)
                                .frame(maxWidth: .infinity)
                            }
                            .background(
                                Color.purple.gradient.opacity(0.8),
                                in: RoundedRectangle(
                                    cornerRadius: 16,
                                    style: .continuous
                                )
                            )
                        }
                    }
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

    private func deleteSearchHistory() {
        do {
            try modelContext.delete(model: SearchItem.self)
        } catch {
            print("Failed to delete all history items.")
        }
    }
}

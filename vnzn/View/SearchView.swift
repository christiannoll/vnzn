import SwiftUI
import SwiftData

struct SearchView: View {

    @StateObject private var viewModel = PostsViewModel()

    @Environment(MetaData.self) var metaData: MetaData
    @Environment(Router.self) var router: Router

    @FocusState private var isSearchFieldFocused: Bool

    @Query(sort: \SearchItem.date, order: .reverse) var searchItems: [SearchItem]

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.searchViewNavigationPath) {
            Group {
                if isSearchFieldFocused {
                    List {
                        if viewModel.searchText.isEmpty {
                            Text("Zuletzt gesucht")
                                .font(.subheadline)
                                .bold()
                            ForEach (searchItems) { searchItem in
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(searchItem.post.title)
                                            .bold()
                                        Spacer()
                                    }
                                    Text(Date.createPostDate(searchItem.post)).foregroundStyle(.secondary).font(.footnote)
                                }
                            }
                        }
                        else {
                            let filteredItems = viewModel.filteredItems
                            ForEach (filteredItems) { post in
                                PostRow(post: post, posts: filteredItems, action: {
                                    SwiftDataService.shared.saveSearchItem(searchTerm: viewModel.searchText, post: post) })
                            }
                        }
                    }
                } else {
                    ScrollView {
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
                    .task {
                        viewModel.fetchPosts()
                        if metaData.tags.tagItems.isEmpty {
                            await metaData.tags.createTags(viewModel.posts)
                        }
                    }
                }
            }
            .navigationTitle("Suchen")
            .selectNavigationDestination()
            .searchable(text: $viewModel.searchText, prompt: "vnzn durchsuchen")
            .searchFocused($isSearchFieldFocused)
        }
    }
}

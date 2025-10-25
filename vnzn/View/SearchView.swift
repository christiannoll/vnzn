import SwiftUI
import SwiftData

struct SearchView: View {

    @State private var searchText = ""
    @Query(sort: \Post.date) var posts: [Post]

    @Environment(MetaData.self) var metaData: MetaData
    @Environment(Router.self) var router: Router

    @FocusState private var isSearchFieldFocused: Bool

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.searchViewNavigationPath) {
            Group {
                if isSearchFieldFocused {
                    
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
                        if metaData.tags.tagItems.isEmpty {
                            await metaData.tags.createTags(posts)
                        }
                    }
                }
            }
            .navigationTitle("Suchen")
            .navigationBarTitleDisplayMode(.inline)
            .selectNavigationDestination()
            .searchable(text: $searchText, prompt: "Inhalt durchsuchen")
            .searchFocused($isSearchFieldFocused)
        }
    }
}

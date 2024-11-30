import SwiftUI
import SwiftData

struct SerialsView: View {

    @State private var searchText = ""

    @Environment(Router.self) var router: Router
    @Query(sort: \Post.date) var posts: [Post]

    let serials: Serials

    var searchResults: [TagItem] {
        if searchText.isEmpty {
            return serials.tagItems
        } else {
            return serials.tagItems.filter { $0.key.contains(searchText) }
        }
    }

    var body: some View {
        //NavigationStack(path: $path) {
            List {
                ForEach(searchResults) { tagItem in
                    Button {
                        router.metaNavigationPath.append(.tag)
                    } label: {
                        Text(tagItem.tagTitle)
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 0))
                }
            }
            .task {
                if serials.tagItems.isEmpty {
                    await serials.createSerials(posts)
                }
            }
            .navigationDestination(for: NavigationState.self) { navState in
                if case .tag = navState {
                    EmptyView()
                    //TagItemView(posts: tagItem.posts, path: $path)
                }
            }
            .searchable(text: $searchText, prompt: "Serien durchsuchen")
            .navigationTitle("Serien")
            .navigationBarTitleDisplayMode(.inline)
            .scrollContentBackground(.hidden)
        //}
    }
}

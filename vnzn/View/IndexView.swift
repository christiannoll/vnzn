import SwiftUI
import SwiftData

struct IndexView: View {
    
    @State private var searchText = ""
    @Query(sort: \Post.date) var posts: [Post]

    @Environment(Index.self) var index: Index
    @Environment(Router.self) var router: Router

    var searchResults: [IndexItem] {
        if searchText.isEmpty {
            return index.indexItems
        } else {
            return index.indexItems.filter { $0.key.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.indexViewNavigationPath) {
            List {
                ForEach(searchResults) { indexItem in
                    Button {
                        router.currentNavigationPath.append(NavigationTarget.indexItem(indexItem))
                    } label: {
                        Text(indexItem.key)
                        Spacer()
                        Text(String(indexItem.numberOfPosts))
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .task {
                if index.indexItems.isEmpty {
                    await index.createIndex(posts)
                }
            }
            .searchable(text: $searchText, prompt: "Index durchsuchen")
            .selectNavigationDestination()
            .navigationTitle("Index")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .tabBar)
        }
    }
}

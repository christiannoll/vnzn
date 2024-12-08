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
            return index.indexItems.filter { $0.key.contains(searchText) }
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
                        Text(indexItem.linkTitle)
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 0))
                }
            }
            .task {
                if index.indexItems.isEmpty {
                    await index.createIndex(posts)
                }
            }
            .searchable(text: $searchText, prompt: "Index durchsuchen")
            .selectNavigationDestination()
            .scrollContentBackground(.hidden)
            .navigationTitle("Index")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .tabBar)
        }
    }
}

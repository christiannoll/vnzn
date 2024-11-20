import SwiftUI
import SwiftData

struct IndexView: View {
    
    @State private var searchText = ""
    @State private var path = NavigationPath()
    
    @Environment(Index.self) var index: Index
    @Query(sort: \Post.date) var posts: [Post]
    
    var searchResults: [IndexItem] {
        if searchText.isEmpty {
            return index.indexItems
        } else {
            return index.indexItems.filter { $0.key.contains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(searchResults) { indexItem in
                    Text(indexItem.linkTitle)
                }
            }
            .task {
                await index.createIndex(posts)
            }
        }
        .searchable(text: $searchText, prompt: "Index durchsuchen")
    }
}

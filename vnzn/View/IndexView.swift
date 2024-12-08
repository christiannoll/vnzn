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
                    Button {
                        path.append(NavigationTarget.indexItem(indexItem))
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
            .navigationDestination(for: NavigationTarget.self) { navTarget in
                switch navTarget {
                case .tag(let tagItem):
                    TagItemView(posts: tagItem.posts, path: $path)
                case .serials:
                    SerialsView(path: $path)
                case .archive:
                    ArchiveView(path: $path)
                case .archiveMonth(let posts):
                    ArchiveMonthView(posts: posts, path: $path)
                case .statistics:
                    StatisticsView(path: $path)
                case .timeline:
                    TimelineView(path: $path)
                case .post(let post):
                    PostView(post: post, path: $path)
                case .indexItem(let indexItem):
                    IndexItemView(posts: indexItem.posts, path: $path)
                }
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("Index")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .tabBar)
        }
    }
}

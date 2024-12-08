import SwiftUI
import SwiftData

struct TagsView: View {
    
    @State private var searchText = ""
    @State private var path = NavigationPath()
    
    @Environment(Tags.self) var tags: Tags
    @Query(sort: \Post.date) var posts: [Post]
    
    var searchResults: [TagItem] {
        if searchText.isEmpty {
            return tags.tagItems
        } else {
            return tags.tagItems.filter { $0.key.contains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(searchResults) { tagItem in
                    Button {
                        path.append(NavigationTarget.tag(tagItem))
                    } label: {
                        Text(tagItem.tagTitle)
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 0))
                }
            }
            .task {
                if tags.tagItems.isEmpty {
                    await tags.createTags(posts)
                }
            }
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
            .searchable(text: $searchText, prompt: "Kategorien durchsuchen")
            .navigationTitle("Kategorien")
            .navigationBarTitleDisplayMode(.inline)
            .scrollContentBackground(.hidden)
            .toolbarBackground(.visible, for: .tabBar)
        }
    }
}

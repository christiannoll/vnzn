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
                        path.append(tagItem)
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
            .searchable(text: $searchText, prompt: "Kategorien durchsuchen")
            .navigationDestination(for: TagItem.self) { tagItem in
                TagItemView(posts: tagItem.posts, path: $path)
            }
            .navigationTitle("Kategorien")
            .navigationBarTitleDisplayMode(.inline)
            .scrollContentBackground(.hidden)
            .toolbarBackground(.visible, for: .tabBar)
        }
    }
}

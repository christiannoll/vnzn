import SwiftUI
import SwiftData

struct TagsView: View {
    
    @State private var searchText = ""
    @Query(sort: \Post.date) var posts: [Post]

    @Environment(Tags.self) var tags: Tags
    @Environment(Router.self) var router: Router
    
    var searchResults: [TagItem] {
        if searchText.isEmpty {
            return tags.tagItems
        } else {
            return tags.tagItems.filter { $0.key.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.tagsViewNavigationPath) {
            List {
                ForEach(searchResults) { tagItem in
                    Button {
                        router.currentNavigationPath.append(NavigationTarget.tag(tagItem))
                    } label: {
                        Text(tagItem.key)
                        Spacer()
                        Text(tagItem.numberOfPosts)
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .task {
                if tags.tagItems.isEmpty {
                    await tags.createTags(posts)
                }
            }
            .selectNavigationDestination()
            .searchable(text: $searchText, prompt: "Kategorien durchsuchen")
            .navigationTitle("Kategorien")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .tabBar)
        }
    }
}

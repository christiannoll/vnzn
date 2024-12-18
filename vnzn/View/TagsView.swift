import SwiftUI
import SwiftData

struct TagsView: View {
    
    @Query(sort: \Post.date) var posts: [Post]

    @Environment(Tags.self) var tags: Tags
    @Environment(Router.self) var router: Router
    
    var body: some View {
        List {
            ForEach(tags.tagItems) { tagItem in
                Button {
                    router.currentNavigationPath.append(NavigationTarget.tag(tagItem))
                } label: {
                    HStack {
                        Text(tagItem.key)
                        Spacer()
                        Text(tagItem.numberOfPosts)
                            .foregroundStyle(.secondary)
                    }
                    .contentShape(Rectangle())
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
        .navigationTitle("Kategorien")
        .navigationBarTitleDisplayMode(.inline)
    }
}

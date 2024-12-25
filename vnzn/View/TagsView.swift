import SwiftUI
import SwiftData

struct TagsView: View {
    
    @Query(sort: \Post.date) var posts: [Post]

    @Environment(MetaData.self) var metaData: MetaData
    @Environment(Router.self) var router: Router
    
    var body: some View {
        List {
            ForEach(metaData.tags.tagItems) { tagItem in
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
            if metaData.tags.tagItems.isEmpty {
                await metaData.tags.createTags(posts)
            }
        }
        .selectNavigationDestination()
        .navigationTitle("Kategorien")
        .navigationBarTitleDisplayMode(.inline)
    }
}

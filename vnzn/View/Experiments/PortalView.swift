import SwiftUI
import SwiftData

struct PortalView: View {

    @Query(sort: \Post.date) var posts: [Post]
    @Environment(MetaData.self) var metaData: MetaData

    var body: some View {
        List {
            if let tagItem = metaData.serials.getSerialsTagItem("Das Portal") {
                ForEach(tagItem.posts) { post in
                    // use something similar to PostDetailView
                    Text(post.data)
                        .textSelection(.enabled)
                }
            }
        }
        .task {
            if metaData.serials.tagItems.isEmpty {
                await metaData.serials.createSerials(posts)
            }
        }
        .navigationTitle("Das Portal")
    }
}

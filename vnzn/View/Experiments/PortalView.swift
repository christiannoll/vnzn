import SwiftUI
import SwiftData

struct PortalView: View {

    @Query(sort: \Post.date) var posts: [Post]
    @Environment(MetaData.self) var metaData: MetaData

    @State private var urlToOpen: URL?
    @State private var isSafariPresented = false

    var body: some View {
        List {
            if let tagItem = metaData.serials.getSerialsTagItem("Das Portal") {
                ForEach(tagItem.posts) { post in
                    if post.type == PostType.text {
                        PostBasicView(posts: posts, selectedPost: post, urlToOpen: $urlToOpen, isSafariPresented: $isSafariPresented)
                            .listRowSeparator(.hidden)
                    }
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

import SwiftUI

struct AiView: View {

    private let key = "Artificial Intelligence"
    @State private var posts: [Post] = []

    @Environment(MetaData.self) var metaData: MetaData

    var body: some View {
        List {
            ForEach (posts) { post in
                PostRow(post: post, posts: posts, action: {})
            }
        }
        .onAppear {
            if let aiIndexItem = metaData.index.indexItems.first( where: { $0.key == key }) {
                posts = aiIndexItem.posts
            }
        }
        .navigationTitle(key)
        .scrollContentBackground(.hidden)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("sort", systemImage: "chevron.up.chevron.down") {
                    posts.reverse()
                }
            }
        }
    }
}

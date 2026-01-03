import SwiftUI

struct ShortStoriesView: View {

    @State private var posts: [Post] = []

    @Environment(MetaData.self) var metaData: MetaData

    var body: some View {
        List {
            ForEach (posts) { post in
                PostRow(post: post, posts: posts, action: {})
            }
        }
        .onAppear {
            if let tagItem = metaData.tags.getTagItem("Short Story") {
                posts = tagItem.posts
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("sort", systemImage: "chevron.up.chevron.down") {
                    posts.reverse()
                }
            }
        }
        .navigationTitle("Kurzgeschichten")
        .scrollContentBackground(.hidden)
    }
}

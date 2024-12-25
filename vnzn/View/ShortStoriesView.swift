import SwiftUI

struct ShortStoriesView: View {

    @State private var posts: [Post] = []

    @Environment(MetaData.self) var metaData: MetaData

    var body: some View {
        List {
            ForEach (posts) { post in
                PostRow(post: post)
            }
        }
        .onAppear {
            if let tagItem = metaData.tags.getTagItem("Short Story") {
                posts = tagItem.posts
            }
        }
        .navigationTitle("Kurzgeschichten")
    }
}

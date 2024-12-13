import SwiftUI

struct ShortStoriesView: View {

    @State private var posts: [Post] = []
    @State private var selectedPost: Post? = nil

    @Environment(Tags.self) var tags: Tags

    var body: some View {
        List {
            ForEach (posts) { post in
                PostRow(post: post, selectedPost: $selectedPost)
            }
        }
        .onAppear {
            if let tagItem = tags.getTagItem("Short Story") {
                posts = tagItem.posts
            }
        }
        .navigationTitle("Kurzgeschichten")
    }
}

import SwiftUI

struct PhotosView: View {
    
    @State private var posts: [Post] = []
    @Environment(Tags.self) var tags: Tags

    var body: some View {
        List {
            ForEach (posts) { post in
                PostRow(post: post)
            }
        }
        .onAppear {
            if let tagItem = tags.getTagItem("Foto") {
                posts = tagItem.posts
            }
        }
        .navigationTitle("Fotos")
    }
}


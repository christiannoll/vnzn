import SwiftUI

struct TagItemView: View {
    
    let posts: [Post]
    @State private var selectedPost: Post? = nil
    
    var body: some View {
        List {
            ForEach (posts) { post in
                PostRow(post: post, selectedPost: $selectedPost)
            }
        }
        .scrollContentBackground(.hidden)
    }
}

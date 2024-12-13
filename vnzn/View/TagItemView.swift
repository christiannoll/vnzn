import SwiftUI

struct TagItemView: View {
    
    let tagItem: TagItem
    @State private var selectedPost: Post? = nil
    
    var body: some View {
        List {
            ForEach (tagItem.posts) { post in
                PostRow(post: post, selectedPost: $selectedPost)
            }
        }
        .navigationTitle(tagItem.key)
        .navigationBarTitleDisplayMode(.inline)
    }
}

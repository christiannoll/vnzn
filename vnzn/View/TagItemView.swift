import SwiftUI

struct TagItemView: View {
    
    let tagItem: TagItem
    
    var body: some View {
        List {
            ForEach (tagItem.posts) { post in
                PostRow(post: post)
            }
        }
        .navigationTitle(tagItem.key)
        .navigationBarTitleDisplayMode(.inline)
    }
}

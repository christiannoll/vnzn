import SwiftUI

struct IndexItemView: View {
    
    let indexItem: IndexItem
    @State private var selectedPost: Post? = nil
    
    var body: some View {
        List {
            ForEach (indexItem.posts) { post in
                PostRow(post: post, selectedPost: $selectedPost)
            }
        }
        .scrollContentBackground(.hidden)
        .navigationTitle(indexItem.key)
        .navigationBarTitleDisplayMode(.inline)
    }
}

import SwiftUI

struct IndexItemView: View {
    
    let indexItem: IndexItem

    var body: some View {
        List {
            ForEach (indexItem.posts) { post in
                PostRow(post: post, posts: indexItem.posts)
            }
            Spacer() // avoid clipping last date in list
        }
        .navigationTitle(indexItem.key)
        .navigationBarTitleDisplayMode(.inline)
        .scrollContentBackground(.hidden)
    }
}

import SwiftUI

struct IndexItemView: View {
    
    let indexItem: IndexItem

    var body: some View {
        List {
            ForEach (indexItem.posts) { post in
                PostRow(post: post)
            }
        }
        .navigationTitle(indexItem.key)
        .navigationBarTitleDisplayMode(.inline)
    }
}

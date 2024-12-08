import SwiftUI

struct RegisterItemView: View {

    let item: RegisterItem
    @State private var selectedPost: Post? = nil

    var body: some View {
        List {
            ForEach (item.posts) { post in
                PostRow(post: post, selectedPost: $selectedPost)
            }
        }
        .navigationTitle(item.content)
    }
}

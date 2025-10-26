import SwiftUI

struct RegisterItemView: View {

    let item: RegisterItem

    var body: some View {
        List {
            ForEach (item.posts) { post in
                PostRow(post: post, posts: item.posts, action: {})
            }
        }
        .navigationTitle(item.content)
    }
}

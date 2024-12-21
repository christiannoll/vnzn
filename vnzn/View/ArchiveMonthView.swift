import SwiftUI

struct ArchiveMonthView: View {

    let posts: [Post]

    var body: some View {
        List {
            ForEach (posts) { post in
                PostRow(post: post)
            }
        }
        .scrollContentBackground(.hidden)
    }
}

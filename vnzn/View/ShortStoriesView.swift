import SwiftUI

struct ShortStoriesView: View {

    @State private var posts: [Post] = []

    @Environment(MetaData.self) var metaData: MetaData

    var body: some View {
        List {
            ForEach (posts) { post in
                PostRow(post: post)
            }
        }
        .onAppear {
            if let tagItem = metaData.tags.getTagItem("Short Story") {
                posts = tagItem.posts
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    posts.reverse()
                } label: {
                    Image(systemName: "chevron.up.chevron.down")
                        .padding(.trailing, 10)
                }
            }
        }
        .navigationTitle("Kurzgeschichten")
        .scrollContentBackground(.hidden)
    }
}

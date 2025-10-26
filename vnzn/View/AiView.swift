import SwiftUI

struct AiView: View {

    @State private var aiIndexItem = IndexItem("")

    @Environment(MetaData.self) var metaData: MetaData

    var body: some View {
        List {
            ForEach (aiIndexItem.posts) { post in
                PostRow(post: post, posts: aiIndexItem.posts, action: {})
            }
        }
        .onAppear {
            aiIndexItem = metaData.index.indexItems.first { $0.key == "Artificial Intelligence"} ?? IndexItem("")
        }
        .navigationTitle(aiIndexItem.key)
        .navigationBarTitleDisplayMode(.inline)
        .scrollContentBackground(.hidden)
    }
}

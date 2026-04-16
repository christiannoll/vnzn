import SwiftUI
import SwiftData

struct SearchIntentView: View {

    let searchText: String

    @Query(sort: \Post.date, order: .reverse) var posts: [Post]

    var searchResults: [Post] {
        if searchText.isEmpty {
            return posts
        } else {
            let searchTerm = searchText.lowercased()
            return posts.filter { $0.data.lowercased().contains(searchTerm) || $0.title.lowercased().contains(searchTerm) }
        }
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible())]) {
                ForEach (searchResults) { post in
                    PostRow(post: post, posts: searchResults, action: {})
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(searchText)
    }
}

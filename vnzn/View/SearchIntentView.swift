import SwiftUI
import SwiftData

struct SearchIntentView: View {

    let searchText: String

    @StateObject private var viewModel = PostsViewModel()
    @State private var dataRetrieved = false

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible())]) {
                let filteredItems = viewModel.filteredItems
                ForEach (filteredItems) { post in
                    PostRow(post: post, posts: filteredItems, action: {})
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(searchText)
        .task {
            if dataRetrieved == false {
                viewModel.fetchPosts()
                viewModel.searchText = searchText
                dataRetrieved = true
            }
        }
    }
}

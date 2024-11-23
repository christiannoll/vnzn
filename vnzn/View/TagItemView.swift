import SwiftUI

struct TagItemView: View {
    
    let posts: [Post]
    @Binding var path: NavigationPath
    @State private var selectedPost: Post? = nil
    
    var body: some View {
        List {
            ForEach (posts) { post in
                PostRow(post: post, selectedPost: $selectedPost, path: $path)
            }
        }
        .navigationDestination(for: Post.self) { post in
            PostView(post: post, path: $path)
        }
        .scrollContentBackground(.hidden)
    }
}

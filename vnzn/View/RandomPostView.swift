import SwiftUI
import SwiftData

struct RandomPostView: View {

    @Query(sort: \Post.date) var posts: [Post]

    var body: some View {
        PostView(post: posts[Int.random(in: 0..<posts.count)])
    }
}

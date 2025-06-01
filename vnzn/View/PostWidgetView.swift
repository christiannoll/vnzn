import SwiftUI
import SwiftData

struct PostWidgetView: View {

    let id: Int

    @Query(sort: \Post.date) var posts: [Post]

    var body: some View {
        if let post = findPost() {
            PostView(post: post, posts: posts)
        } else {
            Text("Kein passender Post gefunden!")
        }
    }

    private func findPost() -> Post? {
        return posts.first(where: { $0.id == id })
    }
}

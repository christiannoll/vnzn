import SwiftUI
import SwiftData

struct PostWidgetView: View {

    let url: URL

    @Query(sort: \Post.date) var posts: [Post]

    var body: some View {
        if let post = findPost() {
            PostView(post: post)
        } else {
            Text("Kein passender Post gefunden!")
        }
    }

    private func findPost() -> Post? {
        let id = parsePostId(from: url)
        return posts.first(where: { $0.id == id })
    }

    private func parsePostId(from url: URL) -> Int {
        var id = -1

        guard url.scheme == "vnznapp" else {
            return id
        }

        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            print("Invalid URL")
            return id
        }

        guard let action = components.host, action == "view-post" else {
            print("Unknown URL, we can't handle this one!")
            return id
        }

        guard let postIdString = components.queryItems?.first(where: { $0.name == "id" })?.value else {
            print("Recipe name not found")
            return id
        }

        id = Int(postIdString) ?? -1

        return id
    }
}

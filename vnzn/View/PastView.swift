import SwiftUI
import SwiftData

struct PastView: View {

    @Query(sort: \Post.date) var posts: [Post]

    var body: some View {
        if let post = fetchPosts() {
            VStack {
                Text(post.title)
                Text(Date.createPostDate(post))
                    .foregroundStyle(.secondary)
            }

        }
    }

    private func fetchPosts() -> Post? {
        let today = Date()
        for i in 1...5 {
            if let sameDay = Calendar.current.date(byAdding: .year, value: -i, to: today) {
                let sameDayNoon = sameDay.noon
                for post in posts {
                    if post.date?.noon == sameDayNoon {
                        return post
                    }
                }
            }
        }
        return nil
    }
}

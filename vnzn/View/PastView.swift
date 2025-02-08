import SwiftUI
import SwiftData

struct PastView: View {

    @Query(sort: \Post.date) var posts: [Post]

    var body: some View {
        List {
            ForEach (fetchPosts()) { post in
                PostRow(post: post)
            }
        }
    }

    private func fetchPosts() -> [Post] {
        var matchingPosts: [Post] = []
        let today = Date()

        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: today)
        let yearUpperBound = currentYear - 2019

        for i in 1...yearUpperBound {
            if let sameDay = Calendar.current.date(byAdding: .year, value: -i, to: today) {
                let sameDayNoon = sameDay.noon
                for post in posts {
                    if post.date?.noon == sameDayNoon {
                        matchingPosts.append(post)
                    }
                }
            }
        }
        return matchingPosts
    }
}

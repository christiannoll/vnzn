import SwiftUI
import SwiftData

struct PastView: View {

    @Query(sort: \Post.date) var posts: [Post]

    var body: some View {
        List {
            ForEach (findMatchingPosts()) { post in
                Text(calcYearDistance(post))
                    .foregroundStyle(Color.secondary)
                    .font(.subheadline)
                    .listRowBackground(Color.clear)
                PostRow(post: post)
            }
        }
        .navigationTitle("Heute")
    }

    private func findMatchingPosts() -> [Post] {
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

    private func calcYearDistance(_ post: Post) -> String {
        var distanceString = ""
        let calendar = Calendar.current

        let today = Date()
        let currentYear = calendar.component(.year, from: today)

        if let date = post.date {
            let postYear = calendar.component(.year, from: date)
            let distance = currentYear - postYear

            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .spellOut
            let stringValue: String = numberFormatter.string(from: NSNumber(value: distance)) ?? ""
            distanceString = "Vor \(stringValue) Jahren:"
        }
        return distanceString
    }
}

import SwiftUI
import SwiftData

struct PastView: View {

    @Query(sort: \Post.date) var posts: [Post]

    @Environment(Router.self) var router: Router

    var body: some View {
        List {
            ForEach (findMatchingPosts()) { post in
                Section(calcYearDistance(post)) {
                    if post.type == PostType.text {
                        VStack(alignment: .leading) {
                            HStack {
                                Text(post.title)
                                Spacer()
                            }
                            .contentShape(Rectangle())
                            Text(Date.createPostDate(post)).foregroundStyle(.secondary)
                        }
                        .listRowInsets(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                        .onTapGesture {
                            router.currentNavigationPath.append(NavigationTarget.post(post))
                        }
                    } else {
                        VStack(alignment: .center) {
                            HStack {
                                Spacer()
                                Button {
                                    router.currentNavigationPath.append(NavigationTarget.post(post))
                                } label: {
                                    PostImage(post: post)
                                        .frame(width: 200, height: 200)
                                        .padding(.top, 30)
                                }
                                Spacer()
                            }
                            Text(Date.createPostDate(post)).foregroundStyle(.secondary)
                        }
                    }
                }
                .listRowSeparator(.hidden)
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

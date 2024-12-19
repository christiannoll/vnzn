import SwiftUI

struct PostOfTheDay: View {

    let posts: [Post]

    @State private var selectedPost: Post
    @Environment(Router.self) var router: Router

    @State private var urlToOpen: URL?
    @State private var isSafariPresented = false

    init(posts: [Post]) {
        self.posts = posts
        _selectedPost = State(initialValue: Post())
    }

    var body: some View {
        Group {
            Text(selectedPost.title)
                .bold()
            Button {
                router.currentNavigationPath.append(NavigationTarget.post(selectedPost))
            } label: {
                PostDataView(post: $selectedPost, urlToOpen: $urlToOpen, isSafariPresented: $isSafariPresented, reduceData: true, posts: posts)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            Text(createPostDate(selectedPost))
                .foregroundStyle(.secondary)
        }
        .background(alignment: .trailing) {
            if let urlToOpen {
                SafariViewControllerPresenter(url: urlToOpen, isPresented: $isSafariPresented)
            }
        }
        .onAppear {
            initPostOfTheDay()
        }
    }

    private func createPostDate(_ post: Post) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "de_DE")
        dateFormatter.dateFormat = "dd MMM yyyy"
        if let date = post.date {
            return dateFormatter.string(from: date)
        } else {
            return ""
        }
    }

    private func initPostOfTheDay() {
        if let data = UserDefaults.standard.data(forKey: "postOfTheDay") {
            do {
                let decoder = JSONDecoder()
                let postOfTheDay = try decoder.decode(RandomPosts.self, from: data)
                let createdAt = Date(timeIntervalSince1970: postOfTheDay.createdAt)
                if Date().noon > createdAt.noon {
                    try setNewPostOfTheDayIndex()
                } else {
                    selectedPost = posts[postOfTheDay.posts[0]]
                }
            } catch {
                print(error.localizedDescription)
            }
        } else {
            do {
                try setNewPostOfTheDayIndex()
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    private func setNewPostOfTheDayIndex() throws {
        var newIndex = 0
        while true {
            let index = Int.random(in: 0..<posts.count)
            if posts[index].type == .text {
                newIndex = index
                break
            }
        }
        let newPostOfTheDay = RandomPosts(createdAt: Date().timeIntervalSince1970, posts: [newIndex])
        let encoder = JSONEncoder()
        let encodedData = try encoder.encode(newPostOfTheDay)
        UserDefaults.standard.set(encodedData, forKey: "postOfTheDay")
        selectedPost = posts[newIndex]
    }
}


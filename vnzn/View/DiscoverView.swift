import SwiftUI
import SwiftData

struct DiscoverView: View {

    @State private var selectedPost: Post

    @Query(sort: \Post.date) var posts: [Post]
    @Environment(Router.self) var router: Router

    @State private var isSafariPresented = false
    @State private var urlToOpen: URL?

    init() {
        _selectedPost = State(initialValue: Post())
    }

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.discoverViewNavigationPath) {
            List {
                Section("Zufälliger Post") {
                    Text(selectedPost.title)
                        .bold()
                    Button {
                        router.currentNavigationPath.append(NavigationTarget.post(selectedPost))
                    } label: {
                        PostDataView(post: $selectedPost, urlToOpen: $urlToOpen, isSafariPresented: $isSafariPresented, reduceData: true, posts: posts)
                    }
                    .background(.black.opacity(0.00001))
                    .buttonStyle(.plain)
                    Text(createPostDate(selectedPost))
                        .foregroundStyle(.secondary)
                }
                .listRowSeparator(.hidden)
            }
            .selectNavigationDestination()
            .navigationTitle("Entdecken")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .tabBar)
        }
        .onAppear {
            selectedPost = posts[Int.random(in: 0..<posts.count)]
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
}

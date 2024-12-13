import SwiftUI
import SwiftData

struct DiscoverView: View {

    @State private var selectedPost: Post? = nil

    @Query(sort: \Post.date) var posts: [Post]
    @Environment(Router.self) var router: Router

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.discoverViewNavigationPath) {
            List {
                let post = posts[Int.random(in: 0..<posts.count)]
                Section("Zufälliger Post") {
                    if post.type == PostType.text {
                        Button {
                            selectedPost = post
                            router.currentNavigationPath.append(NavigationTarget.post(post))
                        } label: {
                            VStack(alignment: .leading) {
                                Text(post.title)
                                Text(createPostDate(post)).foregroundStyle(.secondary)
                            }
                        }
                        .buttonStyle(.plain)
                    } else {
                        VStack(alignment: .center) {
                            HStack {
                                Spacer()
                                Button {
                                    selectedPost = post
                                    router.currentNavigationPath.append(NavigationTarget.post(post))
                                } label: {
                                    PostImage(post: post)
                                        .frame(width: 200, height: 200)
                                        .padding(.top, 30)
                                }
                                Spacer()
                            }
                            Text(createPostDate(post)).foregroundStyle(.secondary)

                        }
                    }
                }
            }
            .selectNavigationDestination()
            .navigationTitle("Entdecken")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .tabBar)
        }
    }

    private func createPostDate(_ post: Post) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "de_DE")
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: post.date!)
    }
}

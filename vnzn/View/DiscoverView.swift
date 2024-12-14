import SwiftUI
import SwiftData

struct DiscoverView: View {

    @State private var selectedPost: Post? = nil

    @Query(sort: \Post.date) var posts: [Post]
    @Environment(Router.self) var router: Router

    private let nodeParser = NodeParser()
    private let stringBuilder = StringBuilder()

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
                                    .bold()
                                ForEach(nodeParser.parse(postExcerpt(post)), id: \.self) { nodes in
                                    if case .curlybraces(_) = nodes.first {
                                        Text(stringBuilder.parse(nodes, post))
                                            .multilineTextAlignment(.center)
                                            .frame(maxWidth: .infinity)
                                            .padding(.bottom, 4)
                                    } else {
                                        Text(stringBuilder.parse(nodes, post))
                                            .multilineTextAlignment(.leading)
                                    }
                                }
                                .padding(.vertical, 4)

                                Text(createPostDate(post))
                                    .foregroundStyle(.secondary)
                            }
                            .background(.black.opacity(0.00001))
                        }
                        .buttonStyle(.plain)
                    } else {
                        VStack(alignment: .center) {
                            Text(post.title)
                                .bold()
                            HStack {
                                Spacer()
                                Button {
                                    selectedPost = post
                                    router.currentNavigationPath.append(NavigationTarget.post(post))
                                } label: {
                                    PostImage(post: post)
                                        .frame(width: 200, height: 200)
                                        .padding(.top, 10)
                                }
                                Spacer()
                            }
                            Text(createPostDate(post))
                                .foregroundStyle(.secondary)
                                .padding(.top, 10)
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

    private func postExcerpt(_ post: Post) -> String {
        let text = post.data
        /*if text.components(separatedBy: "\t* ").count > 3 {
            return text.components(separatedBy: "\t* ").prefix(3).joined(separator: "\t* ") + "\n..."
        }*/
        var excerpt = text.split(separator: "\t").first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if excerpt != text {
            excerpt += "\n..."
        }
        return excerpt
    }
}

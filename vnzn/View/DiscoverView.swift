import SwiftUI
import SwiftData

struct DiscoverView: View {

    @State private var selectedPost: Post

    @Query(sort: \Post.date) var posts: [Post]
    @Environment(Serials.self) var serials: Serials
    @Environment(Router.self) var router: Router

    @State private var isSafariPresented = false
    @State private var urlToOpen: URL?

    @State private var facesPosts: [Post] = []

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    init() {
        _selectedPost = State(initialValue: Post())
    }

    var facesTagItem: TagItem? {
        serials.getTagItem("Fotos: Gesichter")
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
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    Text(createPostDate(selectedPost))
                        .foregroundStyle(.secondary)
                }
                .listRowSeparator(.hidden)
                Section("Fotoserie: Gesichter") {
                    if facesPosts.count > 3 {
                        Grid(horizontalSpacing: 30,
                             verticalSpacing: 30) {
                            GridRow {
                                PostImage(post: facesPosts[0])
                                    .frame(width: 100, height: 100)
                                PostImage(post: facesPosts[1])
                                    .frame(width: 100, height: 100)
                            }
                            GridRow {
                                PostImage(post: facesPosts[2])
                                    .frame(width: 100, height: 100)
                                PostImage(post: facesPosts[3])
                                    .frame(width: 100, height: 100)
                            }
                        }
                    }
                }
                .listRowSeparator(.hidden)
                .onTapGesture {
                    if let tagItem = facesTagItem {
                        router.currentNavigationPath.append(NavigationTarget.tag(tagItem))
                    }
                }
            }
            .environment(\.defaultMinListHeaderHeight, 0)
            .selectNavigationDestination()
            .navigationTitle("Entdecken")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .tabBar)
            .background(alignment: .trailing) {
                if let urlToOpen {
                    SafariViewControllerPresenter(url: urlToOpen, isPresented: $isSafariPresented)
                }
            }
        }
        .onAppear {
            while true {
                let post = posts[Int.random(in: 0..<posts.count)]
                if post.type == .text {
                    selectedPost = post
                    break
                }
            }
        }
        .task {
            if serials.tagItems.isEmpty {
                await serials.createSerials(posts)
            }
            if let tagItem = facesTagItem {
                facesPosts = tagItem.posts
            }
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

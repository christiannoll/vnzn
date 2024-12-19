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
                Section("Post des Tages") {
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
            initPostOfTheDay()
        }
        .task {
            if serials.tagItems.isEmpty {
                await serials.createSerials(posts)
            }
            initFacesPosts()
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

    private func initFacesPosts() {
        if let data = UserDefaults.standard.data(forKey: "facesPosts") {
            do {
                let decoder = JSONDecoder()
                let loadedPostIndices = try decoder.decode(RandomPosts.self, from: data)
                let createdAt = Date(timeIntervalSince1970: loadedPostIndices.createdAt)
                if Date().noon > createdAt.noon {
                    try setNewFacesPostsIndices()
                } else {
                    if let tagItem = facesTagItem {
                        facesPosts.removeAll()
                        for loadedPostIndex in loadedPostIndices.posts {
                            facesPosts.append(tagItem.posts[loadedPostIndex])
                        }
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        } else {
            do {
                try setNewFacesPostsIndices()
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    private func setNewFacesPostsIndices() throws {
        if let tagItem = facesTagItem {
            var indices = (0..<tagItem.posts.count).map { index in index }
            indices.shuffle()
            let newFacesPostsIndices = RandomPosts(createdAt: Date().timeIntervalSince1970, posts: indices)
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(newFacesPostsIndices)
            UserDefaults.standard.set(encodedData, forKey: "facesPosts")
            facesPosts.removeAll()
            for index in indices {
                facesPosts.append(tagItem.posts[index])
            }
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

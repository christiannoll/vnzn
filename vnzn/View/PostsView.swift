import SwiftUI
import SwiftData

struct PostsView: View {
    
    @State private var searchText = ""
    @State private var onlyFavourites = false
    @State private var settingsVisible = false

    @Environment(MetaData.self) var metaData: MetaData
    @Environment(Router.self) var router: Router
    @Query(sort: \Post.date, order: .reverse) var posts: [Post]
    
    var searchResults: [Post] {
        if searchText.isEmpty {
            return posts
        } else {
            let searchTerm = searchText.lowercased()
            return posts.filter { $0.data.lowercased().contains(searchTerm) || $0.title.lowercased().contains(searchTerm) }
        }
    }

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.postsViewNavigationPath) {
            List {
                ForEach (searchResults.filter { shouldInclude($0) }) { post in
                    PostRow(post: post)
                }
            }
            .selectNavigationDestination()
            .searchable(text: $searchText, prompt: "vnzn durchsuchen")
            .scrollContentBackground(.hidden)
            .navigationTitle("v.n.z.n")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarTitleTextColor(.blue)
            .scrollContentBackground(.hidden)
            .task {
                if metaData.tags.tagItems.isEmpty {
                    await metaData.tags.createTags(posts)
                }
                if metaData.index.indexItems.isEmpty {
                    await metaData.index.createIndex(posts)
                }
                if metaData.serials.tagItems.isEmpty {
                    await metaData.serials.createSerials(posts)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        onlyFavourites.toggle()
                    } label: {
                        Image(systemName: onlyFavourites ? "star.fill" : "star")
                            .foregroundStyle(Color.accentColor)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        settingsVisible.toggle()
                    } label: {
                        Image(systemName: "gearshape")
                            .foregroundStyle(Color.accentColor)
                    }
                    .padding(.trailing, 16)
                }
            }
            .toolbarBackground(.visible, for: .tabBar)
            .sheet(isPresented: $settingsVisible) {
                SettingsView()
            }
        }
    }
    
    private func shouldInclude(_ post: Post) -> Bool {
        if onlyFavourites && !post.isFavourite {
            return false
        }
        return true
    }
}

extension View {
    @available(iOS 14, *)
    func navigationBarTitleTextColor(_ color: Color) -> some View {
        let uiColor = UIColor(color)
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor ]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor ]
        return self
    }
}

import SwiftUI
import SwiftData

struct PostsView: View {
    
    @State private var searchText = ""
    @State private var path = NavigationPath()
    @State private var selectedPost: Post? = nil
    @State private var onlyFavourites = false
    
    @Environment(Tags.self) var tags: Tags
    @Query(sort: \Post.date, order: .reverse) var posts: [Post]
    
    var searchResults: [Post] {
        if searchText.isEmpty {
            return posts
        } else {
            return posts.filter { $0.data.contains(searchText) }
        }
    }

    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach (searchResults.filter { shouldInclude($0) }) { post in
                    PostRow(post: post, selectedPost: $selectedPost, path: $path)
                }
            }
            .navigationDestination(for: Post.self) { post in
                PostView(post: post, path: $path)
            }
            .searchable(text: $searchText, prompt: "vnzn durchsuchen")
            .scrollContentBackground(.hidden)
            .navigationTitle("v.n.z.n")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarTitleTextColor(.blue)
            .scrollContentBackground(.hidden)
            .task {
                if tags.tagItems.isEmpty {
                    await tags.createTags(posts)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    VStack {
                        Button {
                            onlyFavourites.toggle()
                        } label: {
                            Image(systemName: onlyFavourites ? "star.fill" : "star")
                                .foregroundStyle(Color.accentColor)
                        }
                        Spacer()
                    }
                    .padding(.trailing, 16)
                }
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

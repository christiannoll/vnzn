import SwiftUI
import SwiftData

struct TimelineView: View {
    
    @State private var searchText = ""
    @State private var path = NavigationPath()
    @State private var selectedPost: Post? = nil
    
    let onlyFavourites: Bool
    
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
                PostView(post: post)
            }
            .searchable(text: $searchText, prompt: "vnzn durchsuchen")
            .scrollContentBackground(.hidden)
            .navigationTitle("v.n.z.n")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarTitleTextColor(.blue)
            .scrollContentBackground(.hidden)
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

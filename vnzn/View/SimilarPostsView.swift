import SwiftUI
import SwiftData
import OSLog

struct SimilarPostsView: View {

    @State private var similarPosts: [Post]

    private static let logger = Logger(subsystem: "de.vnzn.vnzn", category: "SimilarPostsView")

    init(post: Post) {
        similarPosts = Self.fetchSimilarPosts(post: post)
    }

    var body: some View {
        List {
            ForEach (similarPosts) { similarPost in
                PostRow(post: similarPost, posts: similarPosts, action: {})
            }
            if similarPosts.isEmpty {
                Text("Keinen passenden Post gefunden. 🙁")
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    similarPosts.reverse()
                } label: {
                    Image(systemName: "chevron.up.chevron.down")
                        .padding(.leading, 5)
                }
            }
        }
        .navigationTitle("Ähnliche Posts")
        .scrollContentBackground(.hidden)
    }

    static func fetchSimilarPosts(post: Post) -> [Post] {
        var fetchedSimilarPosts: [Post] = []
        do {
            let postFetchDescriptor = FetchDescriptor<Post>(predicate: #Predicate {
                $0.image == nil
            }, sortBy: [ SortDescriptor(\.date, order: .reverse)])
            let fetchedPosts = try SwiftDataService.shared.context.fetch(postFetchDescriptor)
            for fetchedPost in fetchedPosts {
                if fetchedPost.id == post.id { continue }
                if fetchedPost.indices.contains(where: post.indices.contains) {
                    fetchedSimilarPosts.append(fetchedPost)
                }
            }
        } catch {
            logger.error("\(error.localizedDescription)")
        }
        return fetchedSimilarPosts
    }
}

import SwiftUI
import SwiftData

struct SimilarPostsView: View {

    let post: Post
    var similarPosts: [Post] = []

    init(post: Post) {
        self.post = post
        fetchSimilarPosts()
    }

    var body: some View {
        List {
            ForEach (similarPosts) { similarPost in
                PostRow(post: similarPost)
            }
            if similarPosts.isEmpty {
                Text("Keinen passenden Post gefunden. 🙁")
            }
        }
        .navigationTitle("Ähnliche Posts")
        .scrollContentBackground(.hidden)
    }

    mutating func fetchSimilarPosts() {
        do {
            let postFetchDescriptor = FetchDescriptor<Post>(predicate: #Predicate {
                $0.image == nil
            }, sortBy: [ SortDescriptor(\.date, order: .reverse)])
            let fetchedPosts = try SwiftDataService.shared.context.fetch(postFetchDescriptor)
            for fetchedPost in fetchedPosts {
                if fetchedPost.id == post.id { continue }
                if fetchedPost.indices.contains(where: post.indices.contains) {
                    similarPosts.append(fetchedPost)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

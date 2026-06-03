import SwiftUI
import SwiftData
import Combine
import OSLog

@MainActor
class PostsViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    @Published var filteredItems: [Post] = []

    private let logger = Logger(subsystem: "de.vnzn.vnzn", category: "PostsViewModel")

    var posts: [Post] = []

    func fetchPosts() {
        do {
            let postFetchDescriptor = FetchDescriptor<Post>(sortBy: [ SortDescriptor(\.date, order: .reverse)])
            posts = try SwiftDataService.shared.context.fetch(postFetchDescriptor)

            $searchText
                .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main) // Vermeidet ständiges Updaten
                .removeDuplicates()
                .map { searchText in
                    searchText.isEmpty ? self.posts : self.posts.filter { $0.data.localizedCaseInsensitiveContains(searchText) ||
                        $0.title.localizedCaseInsensitiveContains(searchText)}
                }
                .assign(to: &$filteredItems)
        } catch {
            logger.error("\(error.localizedDescription)")
        }
    }
}

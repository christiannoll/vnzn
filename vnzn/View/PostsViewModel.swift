import SwiftUI
import SwiftData
import Combine

@MainActor
class PostsViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    @Published var filteredItems: [Post] = []

    var posts: [Post] = []

    init() {
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
            print(error.localizedDescription)
        }
    }
}

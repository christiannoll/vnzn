import SwiftUI
import SwiftData
import OSLog

struct SearchHistoryView: View {

    @Environment(Router.self) var router: Router
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \SearchItem.date, order: .reverse) var searchItems: [SearchItem]
    @Query(sort: \Post.date) var posts: [Post]

    private let logger = Logger(subsystem: "de.vnzn.vnzn", category: "SearchHistoryView")

    var body: some View {
        @Bindable var router = router
        HStack {
            Text("Zuletzt gesucht")
                .font(.subheadline)
                .bold()
                .padding(4)
            Spacer()
            Button("Löschen") {
                deleteSearchHistory()
            }
            .foregroundStyle(.secondary)
            .font(.subheadline)
            .bold()
            .padding(4)
        }
        ForEach (searchItems) { searchItem in
            Divider()
                .padding(.vertical, 4)
            Button {
                router.currentNavigationPath.append(NavigationTarget.post(searchItem.post, posts))
            } label: {
                VStack(alignment: .leading) {
                    HStack {
                        Text(searchItem.post.title)
                            .bold()
                        Spacer()
                        Text("\"" + searchItem.searchTerm + "\"")
                    }
                    Text(Date.createPostDate(searchItem.post))
                        .font(.footnote)
                }
            }
            .buttonStyle(.plain)
        }
    }

    private func deleteSearchHistory() {
        do {
            try modelContext.delete(model: SearchItem.self)
        } catch {
            logger.error("Failed to delete all history items.")
        }
    }
}

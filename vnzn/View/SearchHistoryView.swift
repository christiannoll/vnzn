import SwiftUI
import SwiftData
import OSLog

struct SearchHistoryView: View {

    @Environment(Router.self) var router: Router
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var viewModel: PostsViewModel
    
    @State private var isDeleteAlertPresented: Bool = false

    @Query(sort: \SearchItem.date, order: .reverse) var searchItems: [SearchItem]

    private let logger = Logger(subsystem: "de.vnzn.vnzn", category: "SearchHistoryView")

    var body: some View {
        @Bindable var router = router
        HStack {
            Text("Zuletzt gefunden")
                .font(.headline)
                .bold()
                .padding(4)
            Spacer()
            Button("Löschen", role: .destructive) {
                isDeleteAlertPresented.toggle()
            }
            .confirmationDialog(
                "Verlauf löschen",
                isPresented: $isDeleteAlertPresented,
                titleVisibility: .hidden
            ) {
                Button("Verlauf löschen") {
                    if searchItems.isEmpty == false {
                        isDeleteAlertPresented.toggle()
                        deleteSearchHistory()
                    }
                }
            }
            .font(.headline)
            .bold()
            .padding(4)
        }
        ForEach (searchItems) { searchItem in
            Divider()
                .padding(.vertical, 4)
            Button {
                router.currentNavigationPath.append(NavigationTarget.post(searchItem.post, viewModel.posts))
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
                .contentShape(Rectangle())
            }
            .padding(.horizontal, 4)
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

import SwiftUI
import SwiftData

struct HistoryView: View {

    @State private var searchText = ""

    @Environment(Router.self) var router: Router
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \HistoryItem.date, order: .reverse) var items: [HistoryItem]

    var searchResults: [HistoryItem] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter {
                let postTitle = $0.post.title
                return postTitle.lowercased().contains(searchText.lowercased())
            }
        }
    }

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.historyViewNavigationPath) {
            List {
                ForEach(searchResults) { item in
                    Button {
                        router.currentNavigationPath.append(NavigationTarget.post(item.post))
                    } label: {
                        HStack {
                            Text(item.post.title)
                            Spacer()
                            Text(Date.createPostDate(item.date))
                                .foregroundStyle(.secondary)
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
            .searchable(text: $searchText, prompt: "Verlauf durchsuchen")
            .selectNavigationDestination()
            .navigationTitle("Verlauf")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        deleteHistory()
                    } label: {
                        Image(systemName: "trash")
                            .padding(.trailing, 10)
                    }
                }
            }
            .toolbarBackground(.visible, for: .tabBar)
        }
    }
    
    private func deleteHistory() {
        do {
            try modelContext.delete(model: HistoryItem.self)
        } catch {
            print("Failed to delete all schools.")
        }
    }
}


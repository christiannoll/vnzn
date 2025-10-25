import SwiftUI
import SwiftData

struct HistoryView: View {

    @State private var searchText = ""

    @Environment(Router.self) var router: Router
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \Post.date) var posts: [Post]
    @Query(sort: \HistoryItem.date, order: .reverse) var items: [HistoryItem]

    @State private var sortOrderReversed: Bool = false

    var searchResults: [HistoryItem] {
        if searchText.isEmpty {
            return sortOrderReversed ? items.reversed() : items
        } else {
            let filteredItems = items.filter {
                let postTitle = $0.post.title
                return postTitle.lowercased().contains(searchText.lowercased())
            }
            return sortOrderReversed ? filteredItems.reversed() : filteredItems
        }
    }

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.historyViewNavigationPath) {
            List {
                ForEach(searchResults) { item in
                    Button {
                        router.currentNavigationPath.append(NavigationTarget.post(item.post, posts))
                    } label: {
                        HStack {
                            if item.post.type == PostType.text {
                                Text(item.post.title)
                            } else {
                                HStack {
                                    PostImage(post: item.post)
                                        .frame(width: 37, height: 37)
                                        .alignmentGuide(.listRowSeparatorLeading) { $0[.leading] }
                                    Text(item.post.title)
                                }
                            }
                            Spacer()
                            Text(Date.createPostDate(item.date))
                                .foregroundStyle(.secondary)
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
                if items.isEmpty {
                    Text("Keinen Historyeintrag gefunden. 🙁")
                }
            }
            .searchable(text: $searchText, prompt: "Verlauf durchsuchen")
            .selectNavigationDestination()
            .navigationTitle("Verlauf")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        deleteHistory()
                    } label: {
                        Image(systemName: "trash")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        sortOrderReversed.toggle()
                    } label: {
                        Image(systemName: "chevron.up.chevron.down")
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


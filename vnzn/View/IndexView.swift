import SwiftUI
import SwiftData

struct IndexView: View {

    @State private var searchText = ""
    @Query(sort: \Post.date) var posts: [Post]

    @Environment(MetaData.self) var metaData: MetaData
    @Environment(Router.self) var router: Router

    var searchResults: [IndexItem] {
        if searchText.isEmpty {
            return metaData.index.indexItems
        } else {
            return metaData.index.indexItems.filter { $0.key.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        @Bindable var router = router
        List {
            ForEach(searchResults) { indexItem in
                Button {
                    router.currentNavigationPath.append(NavigationTarget.indexItem(indexItem))
                } label: {
                    HStack {
                        Text(indexItem.key)
                        Spacer()
                        Text(String(indexItem.numberOfPosts))
                            .foregroundStyle(.secondary)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .task {
            if metaData.index.indexItems.isEmpty {
                await metaData.index.createIndex(posts)
            }
        }
        .selectNavigationDestination()
        .navigationTitle("Index")
        .searchable(text: $searchText, placement: .toolbar, prompt: "Index durchsuchen")
        .searchToolbarBehavior(.minimize)
        .toolbarBackground(.visible, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    sort()
                } label: {
                    Image(systemName: "chevron.up.chevron.down")
                }
            }
        }
    }

    private func sort() {
        metaData.index.sortByNextOrder()
        searchText = " "
        searchText = ""
    }
}

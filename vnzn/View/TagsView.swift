import SwiftUI
import SwiftData

struct TagsView: View {

    @State private var searchText = ""
    @Query(sort: \Post.date) var posts: [Post]

    @Environment(MetaData.self) var metaData: MetaData
    @Environment(Router.self) var router: Router

    var searchResults: [TagItem] {
        if searchText.isEmpty {
            return metaData.tags.tagItems
        } else {
            return metaData.tags.tagItems.filter { $0.key.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        List {
            ForEach(searchResults) { tagItem in
                Button {
                    router.currentNavigationPath.append(NavigationTarget.tag(tagItem))
                } label: {
                    HStack {
                        Text(tagItem.key)
                        Spacer()
                        Text(tagItem.numberOfPosts)
                            .foregroundStyle(.secondary)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .task {
            if metaData.tags.tagItems.isEmpty {
                await metaData.tags.createTags(posts)
            }
        }
        .contentMargins(.top, 0)
        .searchable(text: $searchText, placement: .toolbar, prompt: "Kategorien durchsuchen")
        .searchToolbarBehavior(.minimize)
        .selectNavigationDestination()
        .navigationTitle("Kategorien")
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
        metaData.tags.sortByNextOrder()
        searchText = " "
        searchText = ""
    }
}

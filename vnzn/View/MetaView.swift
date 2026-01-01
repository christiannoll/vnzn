import SwiftUI
import SwiftData

struct MetaView: View {

    @Environment(Router.self) var router: Router
    @Environment(MetaData.self) var metaData: MetaData
    @Environment(SiteStatistics.self) var statistics: SiteStatistics

    @State private var searchText = ""
    @State private var viewModel = MetaViewModel()

    @Query(sort: \Post.date, order: .reverse) var posts: [Post]

    var searchResults: [MetaItem] {
        if searchText.isEmpty {
            return viewModel.metaItems
        } else {
            return viewModel.metaItems.filter { $0.localizedValue.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.metaViewNavigationPath) {
            List {
                ForEach(searchResults, id: \.navigationTarget) { item in
                    MetaViewButton(metaItem: item)
                }
            }
            .task {
                if metaData.serials.tagItems.isEmpty {
                    await metaData.serials.createSerials(posts)
                }
                if metaData.tags.tagItems.isEmpty {
                    await metaData.tags.createTags(posts)
                }
                if metaData.index.indexItems.isEmpty {
                    await metaData.index.createIndex(posts)
                }
                if metaData.archive.years.isEmpty {
                    await metaData.archive.createArchive(posts)
                }
                if metaData.timeline.timelineItems.isEmpty {
                    await metaData.timeline.createTimeline(posts)
                }
                if metaData.persons.register.registerItems.isEmpty {
                    await metaData.persons.createPersonsRegister(posts)
                }
                if metaData.movies.register.registerItems.isEmpty {
                    await metaData.movies.createMoviesRegister(posts)
                }
                if metaData.books.register.registerItems.isEmpty {
                    await metaData.books.createBooksRegister(posts)
                }
                if metaData.indices.register.registerItems.isEmpty {
                    await metaData.indices.createIndexRegister(posts)
                }
                if statistics.data.numberOfPosts == 0 {
                    await statistics.createStatistics(posts, index: metaData.index, tags: metaData.tags, serials: metaData.serials)
                }
            }
            .selectNavigationDestination()
            .navigationTitle("Meta")
            .searchable(text: $searchText, placement: .toolbar, prompt: "Meta durchsuchen")
            .searchToolbarBehavior(.minimize)
            .toolbarBackground(.visible, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("sort", systemImage: "chevron.up.chevron.down") {
                        viewModel.sortByNextOrder()
                        searchText = ""
                    }
                }
            }
        }
    }
}


struct MetaViewButton: View {

    let metaItem: MetaItem

    @Environment(Router.self) var router: Router

    var body: some View {
        @Bindable var router = router
        Button {
            router.currentNavigationPath.append(metaItem.navigationTarget)
        } label: {
            HStack {
                Text(LocalizedStringKey(metaItem.title))
                Spacer()
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

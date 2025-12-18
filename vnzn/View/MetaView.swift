import SwiftUI
import SwiftData

struct MetaView: View {

    @Environment(Router.self) var router: Router
    @Environment(MetaData.self) var metaData: MetaData
    @Environment(SiteStatistics.self) var statistics: SiteStatistics

    @Query(sort: \Post.date, order: .reverse) var posts: [Post]

    private var metaItems = [MetaItem]()

    init() {
        setupItems()
    }

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.metaViewNavigationPath) {
            let _ = print(metaItems)
            List {
                ForEach(metaItems, id: \.navigationTarget) { item in
                    MetaViewButton(metaItem: item)
                }
            }
            .task {
                if metaData.serials.tagItems.isEmpty {
                    await metaData.serials.createSerials(posts)                }
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
            .toolbarBackground(.visible, for: .tabBar)
        }
    }

    private mutating func setupItems() {
        metaItems.append(MetaItem(navigationTarget: .tags, title: "Kategorien"))
        metaItems.append(MetaItem(navigationTarget: .index, title: "Index"))
        metaItems.append(MetaItem(navigationTarget: .serials, title: "Serien"))
        metaItems.append(MetaItem(navigationTarget: .archive, title: "Archiv"))
        metaItems.append(MetaItem(navigationTarget: .statistics, title: "Statistik"))
        metaItems.append(MetaItem(navigationTarget: .timeline, title: "Timeline"))
        metaItems.append(MetaItem(navigationTarget: .persons, title: "Personen"))
        metaItems.append(MetaItem(navigationTarget: .movies, title: "Filme"))
        metaItems.append(MetaItem(navigationTarget: .books, title: "Bücher"))
        metaItems.append(MetaItem(navigationTarget: .photos, title: "Fotos"))
        metaItems.append(MetaItem(navigationTarget: .personsCloud, title: "Personenwolke"))
        metaItems.append(MetaItem(navigationTarget: .topicsCloud, title: "Themenwolke"))
        metaItems.append(MetaItem(navigationTarget: .shortStories, title: "Kurzgeschichten"))
        metaItems.append(MetaItem(navigationTarget: .ai, title: "Artificial Intelligence"))
        metaItems.append(MetaItem(navigationTarget: .experiments, title: "Experimente"))
        metaItems.append(MetaItem(navigationTarget: .randomPost, title: "Zufall"))
    }
}

struct MetaItem {
    let navigationTarget: NavigationTarget
    let title: LocalizedStringKey
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
                Text(metaItem.title)
                Spacer()
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

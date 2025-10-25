import SwiftUI
import SwiftData

struct MetaView: View {

    @Environment(Router.self) var router: Router
    @Environment(MetaData.self) var metaData: MetaData
    @Environment(SiteStatistics.self) var statistics: SiteStatistics

    @Query(sort: \Post.date, order: .reverse) var posts: [Post]

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.metaViewNavigationPath) {
            List {
                Group {
                    MetaViewButton(navigationTarget: .tags, title: "Kategorien")
                    MetaViewButton(navigationTarget: .index, title: "Index")
                    MetaViewButton(navigationTarget: .serials, title: "Serien")
                    MetaViewButton(navigationTarget: .archive, title: "Archiv")
                    MetaViewButton(navigationTarget: .statistics, title: "Statistik")
                    MetaViewButton(navigationTarget: .timeline, title: "Timeline")
                    MetaViewButton(navigationTarget: .persons, title: "Personen")
                    MetaViewButton(navigationTarget: .movies, title: "Filme")
                    MetaViewButton(navigationTarget: .books, title: "Bücher")
                    MetaViewButton(navigationTarget: .photos, title: "Fotos")
                    MetaViewButton(navigationTarget: .personsCloud, title: "Personenwolke")
                    MetaViewButton(navigationTarget: .topicsCloud, title: "Themenwolke")
                    MetaViewButton(navigationTarget: .shortStories, title: "Kurzgeschichten")
                    MetaViewButton(navigationTarget: .ai, title: "Artificial Intelligence")
                    MetaViewButton(navigationTarget: .experiments, title: "Experimente")
                    MetaViewButton(navigationTarget: .randomPost, title: "Zufall")
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
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .tabBar)
        }
    }
}

struct MetaViewButton: View {

    let navigationTarget: NavigationTarget
    let title: LocalizedStringKey

    @Environment(Router.self) var router: Router

    var body: some View {
        @Bindable var router = router
        Button {
            router.currentNavigationPath.append(navigationTarget)
        } label: {
            HStack {
                Text(title)
                Spacer()
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

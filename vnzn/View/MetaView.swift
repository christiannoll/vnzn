import SwiftUI
import SwiftData

struct MetaView: View {

    @Environment(Router.self) var router: Router
    @Environment(Serials.self) var serials: Serials
    @Environment(Index.self) var index: Index
    @Environment(Tags.self) var tags: Tags
    @Environment(Archive.self) var archive: Archive
    @Environment(SiteStatistics.self) var statistics: SiteStatistics
    @Environment(Timeline.self) var timeline: Timeline
    @Environment(PersonsRegister.self) var persons: PersonsRegister
    @Environment(MoviesRegister.self) var movies: MoviesRegister

    @Query(sort: \Post.date, order: .reverse) var posts: [Post]

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.metaViewNavigationPath) {
            List {
                Group {
                    MetaViewButton(navigationTarget: .serials, title: "Serien")
                    MetaViewButton(navigationTarget: .archive, title: "Archiv")
                    MetaViewButton(navigationTarget: .statistics, title: "Statistik")
                    MetaViewButton(navigationTarget: .timeline, title: "Timeline")
                    MetaViewButton(navigationTarget: .persons, title: "Personen")
                    MetaViewButton(navigationTarget: .movies, title: "Filme")
                }
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 0))
            }
            .task {
                if serials.tagItems.isEmpty {
                    await serials.createSerials(posts)
                }
                if tags.tagItems.isEmpty {
                    await tags.createTags(posts)
                }
                if index.indexItems.isEmpty {
                    await index.createIndex(posts)
                }
                if archive.years.isEmpty {
                    await archive.createArchive(posts)
                }
                if statistics.data.numberOfPosts == 0 {
                    await statistics.createStatistics(posts, index: index, tags: tags, serials: serials)
                }
                if timeline.timelineItems.isEmpty {
                    await timeline.createTimeline(posts)
                }
                if persons.register.registerItems.isEmpty {
                    await persons.createPersonsRegister(posts)
                }
                if movies.register.registerItems.isEmpty {
                    await movies.createMoviesRegister(posts)
                }
            }
            .selectNavigationDestination()
            .scrollContentBackground(.hidden)
            .navigationTitle("Meta")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .tabBar)
        }
    }
}

struct MetaViewButton: View {

    let navigationTarget: NavigationTarget
    let title: String

    @Environment(Router.self) var router: Router

    var body: some View {
        @Bindable var router = router
        Button {
            router.currentNavigationPath.append(navigationTarget)
        } label: {
            Text(title)
        }
    }
}

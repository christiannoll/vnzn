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
    @Environment(BooksRegister.self) var books: BooksRegister
    @Environment(IndexRegister.self) var indices: IndexRegister

    @Query(sort: \Post.date, order: .reverse) var posts: [Post]

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.metaViewNavigationPath) {
            List {
                Group {
                    MetaViewButton(navigationTarget: .tags, title: "Kategorien")
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
                    MetaViewButton(navigationTarget: .randomPost, title: "Zufall")
                }
                //.listRowSeparator(.hidden)
                //.listRowInsets(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 0))
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
                if books.register.registerItems.isEmpty {
                    await books.createBooksRegister(posts)
                }
                if indices.register.registerItems.isEmpty {
                    await indices.createIndexRegister(posts)
                }
            }
            .selectNavigationDestination()
            //.scrollContentBackground(.hidden)
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

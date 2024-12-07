import SwiftUI
import SwiftData

struct MetaView: View {

    @Environment(Serials.self) var serials: Serials
    @Environment(Index.self) var index: Index
    @Environment(Tags.self) var tags: Tags
    @Environment(Archive.self) var archive: Archive
    @Environment(SiteStatistics.self) var statistics: SiteStatistics
    @Query(sort: \Post.date, order: .reverse) var posts: [Post]

    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            List {
                Group {
                    Button {
                        path.append(NavigationTarget.serials)
                    } label: {
                        Text("Serien")
                    }
                    Button {
                        path.append(NavigationTarget.archive)
                    } label: {
                        Text("Archiv")
                    }
                    Button {
                        path.append(NavigationTarget.statistics)
                    } label: {
                        Text("Statistik")
                    }
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
            }
            .navigationDestination(for: NavigationTarget.self) { navState in
                switch navState {
                case .serials:
                    SerialsView(path: $path)
                case .archive:
                    ArchiveView(path: $path)
                case .archiveMonth(let posts):
                    ArchiveMonthView(posts: posts, path: $path)
                case .statistics:
                    StatisticsView(path: $path)
                case .post(let post):
                    PostView(post: post, path: $path)
                default:
                    EmptyView()
                }
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("Meta")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .tabBar)
        }
    }
}

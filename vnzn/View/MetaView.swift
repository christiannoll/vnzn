import SwiftUI
import SwiftData

struct MetaView: View {

    @Environment(Serials.self) var serials: Serials
    @Environment(Archive.self) var archive: Archive
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
                }
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 0))
            }
            .task {
                if serials.tagItems.isEmpty {
                    await serials.createSerials(posts)
                }
                if archive.years.isEmpty {
                    await archive.createArchive(posts)
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
                default:
                    EmptyView()
                }
            }
            .navigationTitle("Meta")
            .navigationBarTitleDisplayMode(.inline)
            .scrollContentBackground(.hidden)
        }
    }
}

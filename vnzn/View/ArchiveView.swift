import SwiftUI
import SwiftData

struct ArchiveView: View {

    @Environment(MetaData.self) var metaData: MetaData
    @Query(sort: \Post.date, order: .reverse) var posts: [Post]

    @State var years: [ArchiveYear] = []

    var body: some View {
        ArchiveListView(years: years)
            .navigationTitle("Archiv")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("sort", systemImage: "chevron.up.chevron.down") {
                        years = years.reversed()
                    }
                }
            }
            .task {
                if metaData.archive.years.isEmpty {
                    await metaData.archive.createArchive(posts)
                }
                if years.isEmpty {
                    years = metaData.archive.years
                }
            }
    }
}


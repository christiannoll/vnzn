import SwiftUI
import SwiftData

struct ArchiveView: View {

    @Environment(MetaData.self) var metaData: MetaData
    @Query(sort: \Post.date, order: .reverse) var posts: [Post]

    var body: some View {
        ArchiveListView(metaData: metaData)
            .navigationTitle("Archiv")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        metaData.archive.years.reverse()
                    } label: {
                        Image(systemName: "chevron.up.chevron.down")
                    }
                }
            }
            .task {
                if metaData.archive.years.isEmpty {
                    await metaData.archive.createArchive(posts)
                }
            }
    }
}


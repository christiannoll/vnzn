import SwiftUI
import SwiftData

struct ArchiveView: View {

    @Environment(Archive.self) var archive: Archive
    @Query(sort: \Post.date, order: .reverse) var posts: [Post]

    var body: some View {
        List {
            ForEach(archive.years, id: \.self) { year in
                Text(year.name)
            }
        }
        .task {
            if archive.years.isEmpty {
                await archive.createArchive(posts)
            }
        }
        .navigationTitle("Archiv")
        .navigationBarTitleDisplayMode(.inline)
    }
}


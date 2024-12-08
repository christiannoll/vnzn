import SwiftUI
import SwiftData

struct ArchiveView: View {

    @Environment(Router.self) var router: Router
    @Environment(Archive.self) var archive: Archive
    @Query(sort: \Post.date, order: .reverse) var posts: [Post]

    var body: some View {
        List {
            ForEach(archive.years, id: \.self) { year in
                Text(year.name)
                    .bold()
                ForEach(year.months, id: \.self) { month in
                    Button {
                        router.currentNavigationPath.append(NavigationTarget.archiveMonth(month.posts))
                    } label: {
                        Text(month.monthName)
                    }
                }
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


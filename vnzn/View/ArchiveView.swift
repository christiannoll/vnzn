import SwiftUI
import SwiftData

struct ArchiveView: View {

    @Environment(Router.self) var router: Router
    @Environment(MetaData.self) var metaData: MetaData
    @Query(sort: \Post.date, order: .reverse) var posts: [Post]

    var body: some View {
        List {
            ForEach(metaData.archive.years, id: \.self) { year in
                Text(year.name)
                    .bold()
                ForEach(year.months, id: \.self) { month in
                    Button {
                        router.currentNavigationPath.append(NavigationTarget.archiveMonth(month))
                    } label: {
                        HStack {
                            Text(month.monthName)
                                .foregroundStyle(.secondary)
                            Spacer()
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .task {
            if metaData.archive.years.isEmpty {
                await metaData.archive.createArchive(posts)
            }
        }
        .navigationTitle("Archiv")
        .navigationBarTitleDisplayMode(.inline)
    }
}


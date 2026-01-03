import SwiftUI
import SwiftData

struct SerialsView: View {

    @Query(sort: \Post.date) var posts: [Post]
    @Environment(MetaData.self) var metaData: MetaData
    @Environment(Router.self) var router: Router

    var body: some View {
        List {
            ForEach(metaData.serials.tagItems) { tagItem in
                Button {
                    router.currentNavigationPath.append(NavigationTarget.tag(tagItem))
                } label: {
                    HStack {
                        Text(tagItem.key)
                        Spacer()
                        Text(tagItem.numberOfPosts)
                            .foregroundStyle(.secondary)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("sort", systemImage: "chevron.up.chevron.down") {
                    sort()
                }
            }
        }
        .task {
            if metaData.serials.tagItems.isEmpty {
                await metaData.serials.createSerials(posts)
            }
        }
        .navigationTitle("Serien")
    }

    private func sort() {
        metaData.serials.sortByNextOrder()
    }
}

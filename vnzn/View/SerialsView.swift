import SwiftUI
import SwiftData

struct SerialsView: View {

    @Query(sort: \Post.date) var posts: [Post]
    @Environment(Serials.self) var serials: Serials
    @Environment(Router.self) var router: Router

    var body: some View {
        List {
            ForEach(serials.tagItems) { tagItem in
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
        .task {
            if serials.tagItems.isEmpty {
                await serials.createSerials(posts)
            }
        }
        .navigationTitle("Serien")
        .navigationBarTitleDisplayMode(.inline)
    }
}

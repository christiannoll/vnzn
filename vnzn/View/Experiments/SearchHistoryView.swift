import SwiftUI
import SwiftData

struct SearchHistoryView: View {

    @Environment(Router.self) var router: Router
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \SearchItem.date, order: .reverse) var searchItems: [SearchItem]
    @Query(sort: \Post.date) var posts: [Post]

    var body: some View {
        @Bindable var router = router
        HStack {
            Text("Zuletzt gesucht")
                .font(.subheadline)
                .bold()
                .padding(4)
            Spacer()
            Button("Löschen") {
                deleteSearchHistory()
            }
            .foregroundStyle(.secondary)
            .font(.subheadline)
            .bold()
            .padding(4)
        }
        ForEach (searchItems) { searchItem in
            Divider()
                .padding(.vertical, 4)
            VStack(alignment: .leading) {
                HStack {
                    Text(searchItem.post.title)
                        .bold()
                    Spacer()
                }
                Text(Date.createPostDate(searchItem.post)).foregroundStyle(.secondary).font(.footnote)
            }
            .onTapGesture {
                router.currentNavigationPath.append(NavigationTarget.post(searchItem.post, posts))
            }
        }
    }

    private func deleteSearchHistory() {
        do {
            try modelContext.delete(model: SearchItem.self)
        } catch {
            print("Failed to delete all history items.")
        }
    }
}

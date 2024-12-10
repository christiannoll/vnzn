import SwiftUI
import SwiftData

struct SerialsView: View {

    @State private var searchText = ""

    @Query(sort: \Post.date) var posts: [Post]
    @Environment(Serials.self) var serials: Serials
    @Environment(Router.self) var router: Router

    var searchResults: [TagItem] {
        if searchText.isEmpty {
            return serials.tagItems
        } else {
            return serials.tagItems.filter { $0.key.contains(searchText) }
        }
    }

    var body: some View {
        List {
            ForEach(searchResults) { tagItem in
                Button {
                    router.currentNavigationPath.append(NavigationTarget.tag(tagItem))
                } label: {
                    Text(tagItem.tagTitle)
                }
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 0))
            }
        }
        .padding(.top, 50)
        .task {
            if serials.tagItems.isEmpty {
                await serials.createSerials(posts)
            }
        }
        .searchable(text: $searchText, prompt: "Serien durchsuchen")
        .scrollContentBackground(.hidden)
        .navigationTitle("Serien")
        .navigationBarTitleDisplayMode(.inline)
    }
}

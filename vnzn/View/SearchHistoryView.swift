import SwiftUI
import SwiftData

struct SearchHistoryView: View {

    @Environment(Router.self) var router: Router
    @Query(sort: \SearchItem.date, order: .reverse) var items: [SearchItem]

    var body: some View {
        List {
            ForEach(items) { item in
                Button {
                    router.currentNavigationPath.append(NavigationTarget.searchIntent(item.searchTerm))
                } label: {
                    HStack {
                        Text(item.searchTerm)
                        Spacer()
                        Text(Date.createPostDate(item.date))
                            .foregroundStyle(.secondary)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .navigationTitle("Suchverlauf")
    }
}

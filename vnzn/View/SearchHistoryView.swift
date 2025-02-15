import SwiftUI
import SwiftData

struct SearchHistoryView: View {

    @Query(sort: \SearchItem.date, order: .reverse) var items: [SearchItem]

    var body: some View {
        List {
            ForEach(items) { item in
                Button {
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

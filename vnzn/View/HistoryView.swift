import SwiftUI
import SwiftData

struct HistoryView: View {
    
    @Query(sort: \HistoryItem.date, order: .reverse) var items: [HistoryItem]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    HStack {
                        Text(item.post?.title ?? "")
                        Text(item.date?.description ?? "")
                    }
                }
            }
        }
    }
}


import SwiftUI
import SwiftData

struct QuotesView: View {

    @Environment(MetaData.self) var metaData: MetaData
    @Query(sort: \Post.date, order: .reverse) var posts: [Post]

    var body: some View {
        Group {
            if let indexItem = metaData.index.getIndexItem(itemKey) {
                IndexItemView(indexItem: indexItem)
            } else {
                Text("Keinen passenden Post gefunden. 🙁")
            }
        }
        .task {
            if metaData.index.indexItems.isEmpty {
                await metaData.index.createIndex(posts)
            }
        }
    }

    private var itemKey: String {
        Locale.isEnglish ? "Quote" : "Zitat"
    }
}

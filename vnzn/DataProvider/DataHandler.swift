import Foundation
import SwiftData

@ModelActor
public actor DataHandler {

    @MainActor
    public init(modelContainer: ModelContainer, mainActor _: Bool) {
        let modelContext = modelContainer.mainContext
        modelExecutor = DefaultSerialModelExecutor(modelContext: modelContext)
        self.modelContainer = modelContainer
    }

    func save() {
        do {
            try modelContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }

    func incrementVisits(post: Post) async {
        post.visits += 1
        save()
    }

    func saveHistoryItem(post: Post) async {
        let postId = post.id
        let postPredicate = FetchDescriptor<HistoryItem>(predicate: #Predicate { historyItem in
            postId == historyItem.post.id
        })
        let posts = try? modelContext.fetch(postPredicate)
        if let posts, posts.filter({ $0.date.noon == Date().noon }).isEmpty {
            let item = HistoryItem(date: Date(), post: post)
            modelContext.insert(item)
            save()
        }
    }
}

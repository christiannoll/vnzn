import Foundation
import SwiftData

class SwiftDataService {
    
    @MainActor static let shared = SwiftDataService()
    private var modelContext: ModelContext!
    
    private init() {}
    
    func setup(modelContext: ModelContext) {
        if self.modelContext == nil {
            self.modelContext = modelContext
        }
    }
    
    var context: ModelContext {
        guard let modelContext else {
            fatalError("SwiftDataService is not setup")
        }
        return modelContext
    }

    func incrementVisits(post: Post) {
        post.visits += 1
        try? modelContext.save()
    }

    func saveHistoryItem(post: Post) {
        let postId = post.id
        let postPredicate = FetchDescriptor<HistoryItem>(predicate: #Predicate { historyItem in
            postId == historyItem.post?.id
        })
        let posts = try? modelContext.fetch(postPredicate)
        if let posts, posts.filter({ $0.date?.noon == Date().noon }).isEmpty {
            modelContext.insert(HistoryItem(date: Date(), post: post))
            try? modelContext.save()
        }
    }
}

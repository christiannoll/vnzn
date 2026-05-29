import Foundation
import SwiftData
import OSLog

class SwiftDataService {
    
    @MainActor static let shared = SwiftDataService()
    private var modelContext: ModelContext!
    private let logger = Logger(subsystem: "de.vnzn.vnzn", category: "SwiftDataService")

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

    func save() {
        do {
            try modelContext.save()
        } catch {
            Logger().error("\(error.localizedDescription)")
        }
    }

    func incrementVisits(post: Post) {
        post.visits += 1
        save()
    }

    func saveHistoryItem(post: Post) {
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

    func saveSearchItem(searchTerm: String, post: Post) {
        let item = SearchItem(date: Date(), searchTerm: searchTerm, post: post)
        modelContext.insert(item)
        save()
    }
}

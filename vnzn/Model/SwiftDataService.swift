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
    
    func saveHistoryItem(post: Post) {
        modelContext.insert(HistoryItem(date: Date(), post: post))
        try? modelContext.save()
    }
}

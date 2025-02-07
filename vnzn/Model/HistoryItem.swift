import SwiftData
import Foundation

@Model
final class HistoryItem {
    
    @Attribute(.unique) var date: Date?
    @Relationship(deleteRule: .cascade) var post: Post?

    init(date: Date? = nil, post: Post? = nil) {
        self.date = date
        self.post = post
    }
}

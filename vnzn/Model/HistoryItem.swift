import SwiftData
import Foundation

@Model
final class HistoryItem {
    
    @Attribute(.unique) var date: Date
    var post: Post

    init(date: Date = Date(), post: Post = Post()) {
        self.date = date
        self.post = post
    }
}

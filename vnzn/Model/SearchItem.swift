import SwiftData
import Foundation

@Model
final class SearchItem {

    @Attribute(.unique) var date: Date
    var searchTerm: String
    var post: Post

    init(date: Date = Date(), searchTerm: String = "", post: Post = Post()) {
        self.date = date
        self.searchTerm = searchTerm
        self.post = post
    }
}

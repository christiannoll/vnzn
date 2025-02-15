import SwiftData
import Foundation

@Model
final class SearchItem {

    @Attribute(.unique) var date: Date
    var searchTerm: String

    init(date: Date = Date(), searchTerm: String = "") {
        self.date = date
        self.searchTerm = searchTerm
    }
}

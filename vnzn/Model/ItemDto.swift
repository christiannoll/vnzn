import Foundation

public enum ItemType {
    case text
    case image
}

public struct ItemDto {
    let id: Int
    var data = ""
    var name = ""
    var title = ""
    var date: Date?
    var tags: Set<String> = []
    var indices: Set<String> = []
    var serials: Set<String> = []
    var links: [String: String] = [:]
    var years: [Int] = []
    var persons: Set<String> = []
    var movies: Set<String> = []
    var books: Set<String> = []
    var type: ItemType = .text
    
    init(_ id: Int) {
        self.id = id
    }
}

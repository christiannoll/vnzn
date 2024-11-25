import Foundation

enum ItemType {
    case text
    case image
}

class Item: Identifiable, Hashable {
    public let id: Int
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
    
    init(_ id: Int) {
        self.id = id
    }
    
    func itemType() -> ItemType { return .text }
    func postType() -> PostType { return PostType.text }
    func textFormat() -> String { return "" }
    
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Item: Equatable {
    public static func == (lhs: Item, rhs: Item) -> Bool {
        lhs.id == rhs.id
    }
}

class TextPost: Item {
    var format = "normal"
    
    override func textFormat() -> String {
        format
    }
}

class ImagePost : Item {
    var width = 250
    var height = 250
    
    override func itemType() -> ItemType {
        .image
    }
    
    override func postType() -> PostType {
        PostType.image
    }
}

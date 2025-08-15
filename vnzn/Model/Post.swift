import Foundation
import SwiftData

public enum PostType: Int, Codable, CodingKey {
    case text
    case image
}

@Model
final class Post: Identifiable {
    
    @Attribute(.unique) var id: Int
    var data: String
    var name: String
    var title: String
    var date: Date?
    var tags: Set<String>
    var indices: Set<String>
    var serials: Set<String>
    var links: [String: String]
    var years: [Int]
    var persons: Set<String>
    var movies: Set<String>
    var books: Set<String>
    var type: PostType
    var textFormat: String
    var isFavourite: Bool
    var visits: Int
    @Attribute(.externalStorage) var image: Data?

    init(id: Int = -1, data: String = "", name: String = "", title: String = "", date: Date? = nil, tags: Set<String> = [], indices: Set<String> = [], serials: Set<String> = [], links: [String : String] = [:], years: [Int] = [], persons: Set<String> = [], movies: Set<String> = [], books: Set<String> = [], type: PostType = PostType.text, textFormat: String = "", isFavourite: Bool = false, visits: Int = 0, image: Data? = nil) {
        self.id = id
        self.data = data
        self.name = name
        self.title = title
        self.date = date
        self.tags = tags
        self.indices = indices
        self.serials = serials
        self.links = links
        self.years = years
        self.persons = persons
        self.movies = movies
        self.books = books
        self.type = type
        self.textFormat = textFormat
        self.isFavourite = isFavourite
        self.visits = visits
        self.image = image
    }
}

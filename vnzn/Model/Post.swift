import Foundation
import SwiftData

@Model
final class Post {
    
    @Attribute(.unique) var id: Int
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
    @Relationship(deleteRule: .cascade, inverse: \MetaInfo.post) var metaInfo: MetaInfo
    
    init(id: Int = -1, data: String = "", name: String = "", title: String = "", date: Date? = nil, tags: Set<String> = [], indices: Set<String> = [], serials: Set<String> = [], links: [String : String] = [:], years: [Int] = [], persons: Set<String> = [], movies: Set<String> = [], books: Set<String> = [], metaInfo: MetaInfo = .init()) {
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
        self.metaInfo = metaInfo
    }
}

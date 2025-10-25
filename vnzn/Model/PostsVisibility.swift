import SwiftData

enum PostsLimit: Int, Codable, CodingKey {
    case ten
    case twenty
    case fifty
    case all
}

@Model
final class PostsVisibility {

    var onlyFavourites: Bool
    var oldestFirst: Bool
    var postsLimit: PostsLimit

    init(onlyFavourites: Bool = false, oldestFirst: Bool = false, postsLimit: PostsLimit = .all) {
        self.onlyFavourites = onlyFavourites
        self.oldestFirst = oldestFirst
        self.postsLimit = postsLimit
    }
}

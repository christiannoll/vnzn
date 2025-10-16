import SwiftData

@Model
final class PostsVisibility {

    var onlyFavourites: Bool
    var oldestFirst: Bool

    init(onlyFavourites: Bool = false, oldestFirst: Bool = false) {
        self.onlyFavourites = onlyFavourites
        self.oldestFirst = oldestFirst
    }
}

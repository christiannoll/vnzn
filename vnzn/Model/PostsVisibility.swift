import SwiftData

@Model
final class PostsVisibility {

    var onlyFavourites: Bool

    init(onlyFavourites: Bool = false) {
        self.onlyFavourites = onlyFavourites
    }
}

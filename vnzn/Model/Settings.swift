import Foundation
import SwiftData

@Model
final class Settings {

    var showPostOfTheDay: Bool
    var showFacesPosts: Bool
    var showPosterPosts: Bool

    init(showPostOfTheDay: Bool = true, showFacesPosts: Bool = true, showPosterPosts: Bool = true) {
        self.showPostOfTheDay = showPostOfTheDay
        self.showFacesPosts = showFacesPosts
        self.showPosterPosts = showPosterPosts
    }
}

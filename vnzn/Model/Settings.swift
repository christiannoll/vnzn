import Foundation
import SwiftData

@Model
final class Settings {

    var showPostOfTheDay: Bool
    var showFacesPosts: Bool
    var showPosterPosts: Bool
    var showShortStoryOfTheDay: Bool
    var showQuoteOfTheDay: Bool

    init(showPostOfTheDay: Bool = true, showFacesPosts: Bool = true, showPosterPosts: Bool = true, showShortStoryOfTheDay: Bool = true, showQuoteOfTheDay: Bool = false) {
        self.showPostOfTheDay = showPostOfTheDay
        self.showFacesPosts = showFacesPosts
        self.showPosterPosts = showPosterPosts
        self.showShortStoryOfTheDay = showShortStoryOfTheDay
        self.showQuoteOfTheDay = showQuoteOfTheDay
    }
}

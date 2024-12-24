import Foundation
import SwiftData

@Model
final class Settings {

    var showPostOfTheDay: Bool
    var showFacesPosts: Bool

    init(showPostOfTheDay: Bool = true, showFacesPosts: Bool = true) {
        self.showPostOfTheDay = showPostOfTheDay
        self.showFacesPosts = showFacesPosts
    }
}

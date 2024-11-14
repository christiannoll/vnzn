import Foundation
import SwiftData

@Model
final class MetaInfo {
    
    var post: Post?
    var isFavourite = false
    
    init(post: Post? = nil, isFavourite: Bool = false) {
        self.post = post
        self.isFavourite = isFavourite
    }
}

import Foundation

struct StatisticPostItem {
    
    let post: Post
    let number: Int
        
    init(_ post: Post, _ number: Int) {
        self.post = post
        self.number = number
    }
}

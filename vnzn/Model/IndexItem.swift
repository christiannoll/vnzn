import Foundation

class IndexItem: Identifiable {
    
    private let _key: String
    private var posts: [Post] = []
    
    var key: String {
        get { return _key }
    }
    
    init(_ key: String) {
        self._key = key
    }
    
    var numberOfPosts: Int {
        get { return posts.count }
    }
    
    var linkTitle: String {
        key + " (" + String(posts.count) + ")"
    }
    
    func addPost(_ post: Post) {
        posts.append(post)
    }
}

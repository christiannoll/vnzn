import Foundation

class IndexItem: Identifiable, Hashable {
    
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
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(key)
    }
}

extension IndexItem: Equatable {}

func ==(lhs: IndexItem, rhs: IndexItem) -> Bool {
    lhs.key == rhs.key
}

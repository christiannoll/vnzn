import Foundation

class TagItem: Identifiable, Hashable {
    
    private let _key: String
    private let folderName: String
    var posts: [Post] = []

    var id: String { _key }

    var key: String { _key }
    
    init(_ key: String, _ folderName: String) {
        self._key = key
        self.folderName = folderName
    }

    var numberOfPosts: String {
        "\(posts.count)"
    }

    var tagTitle: String {
        key + " (" + String(posts.count) + ")"
    }

    func isImageTag() -> Bool {
        for post in posts {
            if post.type == .text {
                return false
            }
        }
        return true
    }

    func addPost(_ post: Post) {
        posts.append(post)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(key)
    }
}

extension TagItem: Equatable {}

func ==(lhs: TagItem, rhs: TagItem) -> Bool {
    lhs.key == rhs.key
}

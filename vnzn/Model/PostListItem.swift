import Foundation

class PostListItem {
    
    var posts: [Post] = []

    var numberOfPosts: Int {
        get { return posts.count }
    }
    
    func addPost(_ post: Post) {
        if !containsPost(post) {
            posts.append(post)
        }
    }
    
    private func containsPost(_ newPost: Post) -> Bool {
        for post in posts {
            if post.name == newPost.name {
                return true
            }
        }
        return false
    }
}

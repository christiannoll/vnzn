import SwiftUI

@Observable
class IndexRegister {

    var register = Register()

    func createIndexRegister(_ posts: [Post]) async {
        for post in posts {
            addPost(post)
        }
        register.sort()
    }

    private func addPost(_ post: Post) {
        for indexRegisterItem in register.getRegisterItems(post.indices) {
            indexRegisterItem.addPost(post)
        }
    }
}

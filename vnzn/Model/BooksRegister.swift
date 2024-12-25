import Foundation

class BooksRegister {

    var register = Register()

    func createBooksRegister(_ posts: [Post]) async {
        for post in posts {
            addPost(post)
        }
        register.sort()
    }

    private func addPost(_ post: Post) {
        for booksRegisterItem in register.getRegisterItems(post.books) {
            booksRegisterItem.addPost(post)
        }
    }
}

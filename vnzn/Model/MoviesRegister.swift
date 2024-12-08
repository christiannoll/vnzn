import Foundation

@Observable
class MoviesRegister {

    var register = Register()

    func createMoviesRegister(_ posts: [Post]) async {
        for post in posts {
            addPost(post)
        }
        register.sort()
    }

    private func addPost(_ post: Post) {
        for moviesRegisterItem in register.getRegisterItems(post.movies) {
            moviesRegisterItem.addPost(post)
        }
    }
}

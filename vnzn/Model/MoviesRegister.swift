import Foundation

class MoviesRegister {

    var register = Register()

    @MainActor
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

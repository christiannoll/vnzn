import Foundation

class PersonsRegister {

    var register = Register()

    @MainActor
    func createPersonsRegister(_ posts: [Post]) async {
        for post in posts {
            addPost(post)
        }
        register.sort()
    }

    private func addPost(_ post: Post) {
        for personsRegisterItem in register.getRegisterItems(post.persons) {
            personsRegisterItem.addPost(post)
        }
    }
}

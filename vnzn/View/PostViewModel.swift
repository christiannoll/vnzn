import SwiftUI

@Observable
class PostViewModel {

    var post: Post

    let stringBuilder = StringBuilder()
    let nodeParser = NodeParser()

    init(post: Post) {
        self.post = post
    }

    func sharedText() -> String {
        var text = AttributedString()

        for nodes in nodeParser.parse(post.data) {
            text.append(stringBuilder.parse(nodes, post))
        }
        return String(text.characters)
    }

    func tagStrings() -> [String] {
        post.tags.map { $0 }.sorted()
    }

    func showShareSheet(_ activityVC: UIActivityViewController) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first {
            window.rootViewController?.present(activityVC, animated: true, completion: nil)
        }
    }

    func createPostUrl() -> String {
        //guard let selectedPost = post else { return VnznEnv.baseUrl }
        var url = VnznEnv.baseUrl

        url.append(createDatePath())
        url.append(post.name.trimmingCharacters(in: .whitespacesAndNewlines))
        url.append("/")

        return url
    }

    private func createDatePath() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "de_DE")
        dateFormatter.dateFormat = "yyyy/MM/dd/"
        return dateFormatter.string(from: post.date!)
    }

    private func boldText(_ text: String) -> Text {
        /*let integers = (0...3)
        _ = integers.publisher
                .sink { print("Received \($0)") }*/

        var attributedString = AttributedString(text + " ")
        attributedString.font = .body.bold()
        return Text(attributedString + attributedString)
    }
}

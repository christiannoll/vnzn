import SwiftUI

class PostViewModel: ObservableObject {

    var post: Post

    let stringBuilder = StringBuilder()
    let nodeParser = NodeParser()

    init(post: Post) {
        self.post = post
    }

    @MainActor
    func toggleIsFavourite() {
        post.isFavourite.toggle()
        SwiftDataService.shared.save()
    }

    var contentType: PostType {
        post.type
    }

    func sharedText() -> String {
        var text = AttributedString()

        text.append(AttributedString(post.title))
        text.append(AttributedString("\n\n"))

        for nodes in nodeParser.parse(post.data) {
            text.append(stringBuilder.parse(nodes, post))
        }
        return String(text.characters)
    }

    func sharedImage() -> ShareableImagePost {
        var imagePost = ShareableImagePost()

        if let imageData = post.image, let uiImage = UIImage(data: imageData) {
            imagePost = ShareableImagePost(
                image: Image(uiImage: uiImage),
                title: post.title
            )
        }
        return imagePost
    }

    func tagStrings() -> [String] {
        post.tags.map { $0 }.sorted()
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

struct ShareableImagePost: Transferable {

    static var transferRepresentation: some TransferRepresentation {
        ProxyRepresentation(exporting: \.image)
    }

    public var image: Image
    public var title: String

    init(image: Image = .init(uiImage: UIImage()), title: String = "") {
        self.image = image
        self.title = title
    }
}


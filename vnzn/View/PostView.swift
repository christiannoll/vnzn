import SwiftUI
import SwiftData

struct PostView: View {
    
    @State var post: Post
    let postBuilder = PostBuilder()
    let stringBuilder = StringBuilder()
    let nodeParser = NodeParser()
    //let model: PostViewModel
    
    @Query(sort: \Post.date) var posts: [Post]

    @State private var isSafariPresented = false
    @State private var urlToOpen: URL?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Text(post.title)
                        .font(.title2)
                        .bold()
                    Spacer()
                }
                .padding(.top, 60)
                .padding(.bottom, 20)
                if post.type == .text {
                    ForEach(nodeParser.parse(post.data), id: \.self) { nodes in
                        if case .curlybraces(_) = nodes.first {
                            Text(stringBuilder.parse(nodes))
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                                .padding(.bottom, 4)
                        } else {
                            Text(stringBuilder.parse(nodes))
                                .multilineTextAlignment(.leading)
                        }
                    }
                } else {
                    PostImage(post: post)
                        .frame(width: 300, height: 300)
                }
                HStack {
                    Text(createPostDate(post)).foregroundStyle(.secondary)
                    Spacer()
                }
                .padding(.top, 6)
                Spacer()
            }
            .padding(.horizontal)
            .environment(\.openURL, OpenURLAction { url in
                if url.absoluteString.starts(with: "#") {
                    if let foundPost = findPost(url: url) {
                        post = foundPost
                    }
                } else {
                    urlToOpen = url
                    DispatchQueue.main.async {
                        isSafariPresented = true
                    }
                }
                return .handled
            })
            .background(alignment: .trailing) {
                if let urlToOpen {
                    SafariViewControllerPresenter(url: urlToOpen, isPresented: $isSafariPresented)
                }
            }
        }
    }
    
    private func createPostDate(_ post: Post) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "de_DE")
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: post.date!)
    }
    
    private func createPostUrl(_ post: Post?) -> String {
        guard let selectedPost = post else { return "https://www.vnzn.de/" }
        var url = "https://www.vnzn.de/"
        
        url.append(createDatePath(selectedPost))
        url.append(selectedPost.name.trimmingCharacters(in: .whitespacesAndNewlines))
        url.append("/")
        
        return url
    }
    
    private func createDatePath(_ post: Post) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "de_DE")
        dateFormatter.dateFormat = "yyyy/MM/dd/"
        return dateFormatter.string(from: post.date!)
    }

    private func boldText(_ text: String) -> Text {
        let integers = (0...3)
        _ = integers.publisher
                .sink { print("Received \($0)") }
        
        var attributedString = AttributedString(text + " ")
        attributedString.font = .body.bold()
        return Text(attributedString + attributedString)
    }
    
    private func findPost(url: URL) -> Post? {
        var foundPost: Post?
        if let postUrl = URL(string: String(url.absoluteString.dropFirst())) {
            foundPost = posts.first(where: { $0.name == postUrl.pathComponents.last! })
        }
        return foundPost
    }
}



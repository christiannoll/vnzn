import SwiftUI
import SwiftData

struct PostView: View {
    
    @State var post: Post
    let postBuilder = PostBuilder()
    let stringBuilder = StringBuilder()
    let nodeParser = NodeParser()
    
    @Query(sort: \Post.date) var posts: [Post]
    @Environment(Tags.self) var tags: Tags
    @Environment(Router.self) var router: Router
    @Environment(\.modelContext) private var modelContext

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
                            Text(stringBuilder.parse(nodes, post))
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                                .padding(.bottom, 4)
                        } else {
                            Text(stringBuilder.parse(nodes, post))
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
                HStack {
                    ForEach(post.tags.map { $0 }, id: \.self) { tag in
                        Button {
                            if let tagItem = tags.getTagItem(tag) {
                                router.currentNavigationPath.append(NavigationTarget.tag(tagItem))
                            }
                        } label: {
                            Text("#" + tag + " ")
                                .foregroundStyle(Color.accentColor)
                                .font(.footnote)
                        }
                    }
                }
                .padding(.top, 6)
                Spacer()
            }
            .padding(.horizontal)
            .environment(\.openURL, OpenURLAction { url in
                if url.absoluteString.starts(with: "#serials") {
                    router.currentNavigationPath.append(NavigationTarget.serials)
                }
                else if url.absoluteString.starts(with: "#archive") {
                    router.currentNavigationPath.append(NavigationTarget.archive)
                }
                else if url.absoluteString.starts(with: "#statistic") {
                    router.currentNavigationPath.append(NavigationTarget.statistics)
                }
                else if url.absoluteString.starts(with: "#timeline") {
                    router.currentNavigationPath.append(NavigationTarget.timeline)
                }
                else if url.absoluteString.starts(with: "#persons") {
                    router.currentNavigationPath.append(NavigationTarget.persons)
                }
                else if url.absoluteString.starts(with: "#movies") {
                    router.currentNavigationPath.append(NavigationTarget.movies)
                }
                else if url.absoluteString.starts(with: "#") {
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
        .onAppear {
            SwiftDataService.shared.saveHistoryItem(post: post)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                VStack {
                    HStack {
                        Button {
                            post.isFavourite.toggle()
                            try? modelContext.save()
                        } label: {
                            Image(systemName: post.isFavourite ? "star.fill" : "star")
                                .foregroundStyle(Color.accentColor)
                        }
                        ShareLink(item: URL(string: "https://www.vnzn.de")!) {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundStyle(Color.accentColor)
                        }
                    }
                    Spacer()
                }
                .padding(.trailing, 16)
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
        guard let selectedPost = post else { return VnznEnv.baseUrl }
        var url = VnznEnv.baseUrl
        
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
        /*let integers = (0...3)
        _ = integers.publisher
                .sink { print("Received \($0)") }*/
        
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



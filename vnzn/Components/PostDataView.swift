import SwiftUI
import SwiftData

struct PostDataView: View {

    @Binding var post: Post
    @Binding var urlToOpen: URL?
    @Binding var isSafariPresented: Bool

    let stringBuilder = StringBuilder()
    let nodeParser = NodeParser()
    var reduceData = false

    @Environment(Tags.self) var tags: Tags
    @Environment(Index.self) var index: Index
    @Environment(Router.self) var router: Router

    var posts: [Post]

    var body: some View {
        Group {
            if post.type == .text {
                ForEach(nodeParser.parse(data(post)), id: \.self) { nodes in
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
                    .frame(width: reduceData ? 200 : 300, height: reduceData ? 200 : 300)
            }
        }
        .environment(\.openURL, OpenURLAction { url in
            return handleLink(url)
        })
    }

    private func handleLink(_ url: URL) -> OpenURLAction.Result {
        if url.absoluteString == "#beta/" {
            router.selectedTab = .meta
            router.resetNavigation()
        }
        else if url.absoluteString == "#" {
            router.selectedTab = .posts
            router.resetNavigation()
        }
        else if url.absoluteString.starts(with: "#serials") {
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
        else if url.absoluteString.starts(with: "#books") {
            router.currentNavigationPath.append(NavigationTarget.books)
        }
        else if url.absoluteString.starts(with: "#tags/Foto") {
            router.currentNavigationPath.append(NavigationTarget.photos)
        }
        else if url.absoluteString.starts(with: "#tags/Short-Story") {
            router.currentNavigationPath.append(NavigationTarget.shortStories)
        }
        else if url.absoluteString.starts(with: "#experiments") {
            router.currentNavigationPath.append(NavigationTarget.experiments)
        }
        else if url.absoluteString.starts(with: "#random") {
            router.currentNavigationPath.append(NavigationTarget.randomPost)
        }
        else if url.absoluteString.starts(with: "#personcloud") {
            router.currentNavigationPath.append(NavigationTarget.personsCloud)
        }
        else if url.absoluteString.starts(with: "#wordcloud") {
            router.currentNavigationPath.append(NavigationTarget.topicsCloud)
        }
        else if url.absoluteString.starts(with: "#tags/") {
            let components = url.absoluteString.components(separatedBy: "/")
            if components.count == 3 {
                if let tagItem = tags.getTagItem(components[1]) {
                    router.currentNavigationPath.append(NavigationTarget.tag(tagItem))
                }
            }
        }
        else if url.absoluteString.starts(with: "#index/") {
            let components = url.absoluteString.components(separatedBy: "/")
            if components.count == 3 {
                let key = components[1].replacingOccurrences(of: "-", with: " ")
                if let indexItem = index.getIndexItem(key) {
                    router.currentNavigationPath.append(NavigationTarget.indexItem(indexItem))
                }
            }
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
    }

    private func findPost(url: URL) -> Post? {
        var foundPost: Post?
        if let postUrl = URL(string: String(url.absoluteString.dropFirst())) {
            foundPost = posts.first(where: { $0.name == postUrl.pathComponents.last! })
        }
        return foundPost
    }

    private func data(_ post: Post) -> String {
        reduceData ? postExcerpt(post) : post.data
    }

    private func postExcerpt(_ post: Post) -> String {
        let text = post.data
        /*if text.components(separatedBy: "\t* ").count > 3 {
            return text.components(separatedBy: "\t* ").prefix(3).joined(separator: "\t* ") + "\n..."
        }*/
        var excerpt = text.split(separator: "\t").first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if excerpt != text {
            excerpt += "\n..."
        }
        return excerpt
    }
}

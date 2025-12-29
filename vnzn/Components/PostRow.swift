import SwiftUI

struct PostRow: View {
    
    let post: Post
    let posts: [Post]
    let action: () -> Void

    @Environment(Router.self) var router: Router

    let stringBuilder = StringBuilder()
    let nodeParser = NodeParser()

    var body: some View {
        if post.type == PostType.text {
            VStack(alignment: .leading) {
                HStack {
                    Text(post.title)
                        .padding(.top, 30)
                        .bold()
                    Spacer()
                }
                Text(text())
                    .lineLimit(2)
                    .padding(.vertical, 1)
                .contentShape(Rectangle())
                Text(Date.createPostDate(post)).foregroundStyle(.secondary)
            }
            .environment(\.openURL, OpenURLAction { _ in
                action()
                return handleLink()
            })
            .onTapGesture {
                router.currentNavigationPath.append(NavigationTarget.post(post, posts))
                action()
            }
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 0, leading: 6, bottom: 10, trailing: 6))
            .listRowBackground(Color.clear)
        } else {
            VStack(alignment: .center) {
                HStack {
                    Spacer()
                    Button {
                        router.currentNavigationPath.append(NavigationTarget.post(post, posts))
                        action()
                    } label: {
                        PostImage(post: post)
                            .frame(width: 200, height: 200)
                            .padding(.top, 30)
                    }
                    Spacer()
                }
                Text(Date.createPostDate(post)).foregroundStyle(.secondary)
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
        }
    }

    private func text() -> AttributedString {
        var text = AttributedString()

        for nodes in nodeParser.parse(post.data) {
            text.append(stringBuilder.parse(nodes, post))
        }
        return text
    }

    private func handleLink() -> OpenURLAction.Result {
        router.currentNavigationPath.append(NavigationTarget.post(post, posts))
        return .handled
    }
}


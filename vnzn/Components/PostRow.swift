import SwiftUI

struct PostRow: View {
    
    let post: Post
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
            .onTapGesture {
                router.currentNavigationPath.append(NavigationTarget.post(post))
            }
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowBackground(Color.clear)
        } else {
            VStack(alignment: .center) {
                HStack {
                    Spacer()
                    Button {
                        router.currentNavigationPath.append(NavigationTarget.post(post))
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

    private func text() -> String {
        var text = AttributedString()

        for nodes in nodeParser.parse(post.data) {
            text.append(stringBuilder.parse(nodes, post))
        }
        return String(text.characters)
    }
}


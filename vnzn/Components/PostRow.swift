import SwiftUI

struct PostRow: View {
    
    let post: Post
    @Environment(Router.self) var router: Router

    var body: some View {
        if post.type == PostType.text {
            VStack(alignment: .leading) {
                HStack {
                    Text(post.title)
                        .padding(.top, 20)
                    Spacer()
                }
                .contentShape(Rectangle())
                Text(createPostDate(post)).foregroundStyle(.secondary)
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
                Text(createPostDate(post)).foregroundStyle(.secondary)
            }
            .listRowBackground(Color.clear)
        }
    }
    
    private func createPostDate(_ post: Post) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "de_DE")
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: post.date!)
    }
}


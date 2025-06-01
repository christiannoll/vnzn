import SwiftUI

struct PostDetailView: View {

    let posts: [Post]

    @State private var selectedPost: Post
    @Environment(Router.self) var router: Router

    @Binding private var urlToOpen: URL?
    @Binding private var isSafariPresented: Bool

    init(posts: [Post], selectedPost: Post, urlToOpen: Binding<URL?>, isSafariPresented: Binding<Bool>) {
        self.posts = posts
        self._urlToOpen = urlToOpen
        self._isSafariPresented = isSafariPresented
        self.selectedPost = selectedPost
    }

    var body: some View {
        Group {
            Text(selectedPost.title)
                .bold()
            Button {
                router.currentNavigationPath.append(NavigationTarget.post(selectedPost))
            } label: {
                PostDataView(post: selectedPost, urlToOpen: $urlToOpen, isSafariPresented: $isSafariPresented, reduceData: true, posts: posts)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            Text(Date.createPostDate(selectedPost))
                .foregroundStyle(.secondary)
        }
    }

}

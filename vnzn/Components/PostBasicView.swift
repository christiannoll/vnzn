import SwiftUI

struct PostBasicView: View {

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
        PostDataView(post: $selectedPost, urlToOpen: $urlToOpen, isSafariPresented: $isSafariPresented, reduceData: false, posts: posts)
    }
}


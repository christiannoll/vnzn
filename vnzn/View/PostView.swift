import SwiftUI
import SwiftData

struct PostView: View {

    let posts: [Post]
    @Environment(MetaData.self) var metaData: MetaData
    @Environment(Router.self) var router: Router

    @State private var isSafariPresented = false
    @State private var urlToOpen: URL?

    @State private var viewModel: PostViewModel

    init(post: Post, posts: [Post]) {
        _viewModel = State(wrappedValue: PostViewModel(post: post))
        self.posts = posts
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Text(viewModel.post.title)
                        .font(.title2)
                        .bold()
                        .accessibilityAddTraits(.isHeader)
                    Spacer()
                }
                .padding(.top, 60)
                .padding(.bottom, 20)
                PostDataView(post: $viewModel.post, urlToOpen: $urlToOpen,
                             isSafariPresented: $isSafariPresented, posts: posts)
                HStack {
                    Text(Date.createPostDate(viewModel.post)).foregroundStyle(.secondary)
                    Spacer()
                }
                .padding(.top, 6)
                HStack {
                    tagButtons
                }
                .padding(.top, 6)
                Spacer()
            }
            .padding(.horizontal)
            .onChange(of: isSafariPresented) {
                if let urlToOpen, isSafariPresented {
                    router.currentNavigationPath.append(NavigationTarget.web(urlToOpen))
                    isSafariPresented = false
                }
            }
        }
        .onDisappear {
            DispatchQueue.main.async {
                SwiftDataService.shared.saveHistoryItem(post: viewModel.post)
                SwiftDataService.shared.incrementVisits(post: viewModel.post)
            }
        }
        .toolbar {
            ToolbarItem {
                Button("Favourite", systemImage: viewModel.post.isFavourite ? "star.fill" : "star") {
                    viewModel.toggleIsFavourite()
                }
            }

            ToolbarSpacer(.fixed)

            ToolbarItem {
                Menu("menu", systemImage: "square.and.arrow.up") {
                    if let url = URL(string: viewModel.createPostUrl()) {
                        ShareLink(item: url) {
                            Label("Link teilen", systemImage: "link")
                        }
                    }
                    if viewModel.contentType == .text {
                        ShareLink(item: viewModel.sharedText()) {
                            Label("Inhalt teilen", systemImage: "text.alignleft")
                        }
                    } else {
                        let sharedImage = viewModel.sharedImage()
                        ShareLink(item: sharedImage, preview: SharePreview(sharedImage.title, image: sharedImage.image)) {
                            Label("Inhalt teilen", systemImage: "photo")
                        }
                    }
                }
            }
        }
    }

    private func photoTagItem(_ tagItemKey: String) -> TagItem? {
        metaData.serials.getTagItem(tagItemKey)
    }

    @ViewBuilder
    private var tagButtons: some View {
        ForEach(viewModel.tagStrings(), id: \.self) { tag in
            Button {
                if let tagItem = metaData.tags.getTagItem(tag) {
                    router.currentNavigationPath.append(NavigationTarget.tag(tagItem))
                }
            } label: {
                Text("#" + tag + " ")
                    .foregroundStyle(Color.accentColor)
                    .font(.footnote)
                    .lineLimit(1)
            }
        }
        if viewModel.post.type == .text {
            Button {
                router.currentNavigationPath.append(NavigationTarget.similarPosts(viewModel.post))
            } label: {
                Text("#Ähnliche Posts")
                    .foregroundStyle(Color.accentColor)
                    .font(.footnote)
                    .lineLimit(1)
            }
        } else if viewModel.post.type == .image {
            ForEach(Array(viewModel.post.serials.enumerated()), id: \.offset) { _, title in
                Button {
                    if let tagItem = photoTagItem(title) {
                        router.currentNavigationPath.append(NavigationTarget.tag(tagItem))
                    }
                } label: {
                    Text(title)
                        .foregroundStyle(Color.accentColor)
                        .font(.footnote)
                        .lineLimit(1)
                }
            }
        }
    }
}




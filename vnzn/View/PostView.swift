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
                    ForEach(viewModel.tagStrings(), id: \.self) { tag in
                        Button {
                            if let tagItem = metaData.tags.getTagItem(tag) {
                                router.currentNavigationPath.append(NavigationTarget.tag(tagItem))
                            }
                        } label: {
                            Text("#" + tag + " ")
                                .foregroundStyle(Color.accentColor)
                                .font(.footnote)
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
                    }
                }
                .padding(.top, 6)
                Spacer()
            }
            .padding(.horizontal)
            /*.background(alignment: .trailing) {
                if let urlToOpen {
                    SafariViewControllerPresenter(url: urlToOpen, isPresented: $isSafariPresented)
                }
            }*/
            .onChange(of: isSafariPresented) {
                if let urlToOpen, isSafariPresented {
                    router.currentNavigationPath.append(NavigationTarget.web(urlToOpen))
                    isSafariPresented = false
                }
            }
        }
        .onAppear {
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
                Menu("menu", systemImage: "ellipsis") {
                    if let url = URL(string: viewModel.createPostUrl()) {
                        ShareLink("Link teilen", item: url)
                    }
                    if viewModel.contentType == .text {
                        ShareLink("Inhalt teilen", item: viewModel.sharedText())
                    } else {
                        let sharedImage = viewModel.sharedImage()
                        ShareLink("Inhalt teilen", item: sharedImage, preview: SharePreview(sharedImage.title, image: sharedImage.image))
                    }
                }
            }
        }
    }

    private func nextPost(_ currentId: Int) -> Post? {
        posts.first { $0.id == viewModel.post.id - 1 }
    }
}




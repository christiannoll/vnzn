import SwiftUI
import SwiftData

struct PostView: View {

    let posts: [Post]
    @Environment(MetaData.self) var metaData: MetaData
    @Environment(Router.self) var router: Router

    @State private var isSafariPresented = false
    @State private var urlToOpen: URL?

    @StateObject private var viewModel: PostViewModel

    init(post: Post, posts: [Post]) {
        _viewModel = StateObject(wrappedValue: PostViewModel(post: post))
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
                Button("test", systemImage: viewModel.post.isFavourite ? "star.fill" : "star") {
                    viewModel.toggleIsFavourite()
                }
            }

            ToolbarSpacer(.fixed)

            ToolbarItem {
                Menu("menu", systemImage: "ellipsis.circle") {
                    Button() {
                        if let url = URL(string: viewModel.createPostUrl()) {
                            let items: [Any] = [url]
                            let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
                            viewModel.showShareSheet(activityVC)
                        }
                    } label: {
                        Label("Link teilen", systemImage: "square.and.arrow.up")
                    }
                    Button {
                        let textToShare = viewModel.sharedText()
                        let items: [Any] = [textToShare]
                        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)

                        viewModel.showShareSheet(activityVC)
                    } label: {
                        Text("Öffnen mit")
                    }
                }
            }
        }
    }

    private func nextPost(_ currentId: Int) -> Post? {
        posts.first { $0.id == viewModel.post.id - 1 }
    }
}




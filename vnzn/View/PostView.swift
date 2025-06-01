import SwiftUI
import SwiftData

struct PostView: View {

    @Query(sort: \Post.date) var posts: [Post]
    @Environment(MetaData.self) var metaData: MetaData
    @Environment(Router.self) var router: Router

    @Environment(\.createDataHandler) private var createDataHandler

    @State private var isSafariPresented = false
    @State private var urlToOpen: URL?

    @State private var viewModel: PostViewModel

    init(post: Post) {
        _viewModel = State(initialValue: PostViewModel(post: post))
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
                PostDataView(post: viewModel.post, urlToOpen: $urlToOpen,
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
            .background(alignment: .trailing) {
                if let urlToOpen {
                    SafariViewControllerPresenter(url: urlToOpen, isPresented: $isSafariPresented)
                }
            }
            .gesture(
                DragGesture(minimumDistance: 100)
                    .onEnded { value in
                        // Detect left swipe
                        if value.location.x - value.startLocation.x < 0 {
                            if let nextPost = nextPost(viewModel.post.id) {
                                router.currentNavigationPath.append(NavigationTarget.post(nextPost))
                            }
                        }
                    }
            )
        }
        .onAppear {
            /*DispatchQueue.main.async {
                SwiftDataService.shared.saveHistoryItem(post: viewModel.post)
                SwiftDataService.shared.incrementVisits(post: viewModel.post)
            }*/
            let createDataHandler = createDataHandler
            Task.detached(priority: .background) {
                if let dataHandler = await createDataHandler() {
                    await dataHandler.saveHistoryItem(post: viewModel.post)
                    await dataHandler.incrementVisits(post: viewModel.post)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                VStack {
                    HStack {
                        Button {
                            viewModel.toggleIsFavourite()
                        } label: {
                            Image(systemName: viewModel.post.isFavourite ? "star.fill" : "star")
                                .foregroundStyle(Color.accentColor)
                        }
                        Menu {
                            Button {
                                if let url = URL(string: viewModel.createPostUrl()) {
                                    let items: [Any] = [url]
                                    let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
                                    viewModel.showShareSheet(activityVC)
                                }
                            } label: {
                                Text("Link teilen")
                            }
                            Button {
                                let textToShare = viewModel.sharedText()
                                let items: [Any] = [textToShare]
                                let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)

                                viewModel.showShareSheet(activityVC)
                            } label: {
                                Text("Öffnen mit")
                            }
                        } label: {
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

    private func nextPost(_ currentId: Int) -> Post? {
        posts.first { $0.id == viewModel.post.id - 1 }
    }
}



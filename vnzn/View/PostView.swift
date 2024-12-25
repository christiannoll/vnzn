import SwiftUI
import SwiftData

struct PostView: View {
    
    @State var post: Post
    
    @Query(sort: \Post.date) var posts: [Post]
    @Environment(MetaData.self) var metaData: MetaData
    @Environment(Router.self) var router: Router
    @Environment(\.modelContext) private var modelContext

    @State private var isSafariPresented = false
    @State private var urlToOpen: URL?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Text(post.title)
                        .font(.title2)
                        .bold()
                    Spacer()
                }
                .padding(.top, 60)
                .padding(.bottom, 20)
                PostDataView(post: $post, urlToOpen: $urlToOpen,
                             isSafariPresented: $isSafariPresented, posts: posts)
                HStack {
                    Text(createPostDate(post)).foregroundStyle(.secondary)
                    Spacer()
                }
                .padding(.top, 6)
                HStack {
                    ForEach(tagStrings(), id: \.self) { tag in
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
        }
        .onAppear {
            DispatchQueue.main.async {
                SwiftDataService.shared.saveHistoryItem(post: post)
                SwiftDataService.shared.incrementVisits(post: post)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                VStack {
                    HStack {
                        Button {
                            post.isFavourite.toggle()
                            DispatchQueue.main.async {
                                try? modelContext.save()
                            }
                        } label: {
                            Image(systemName: post.isFavourite ? "star.fill" : "star")
                                .foregroundStyle(Color.accentColor)
                        }
                        ShareLink(item: URL(string: "https://www.vnzn.de")!) {
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

    private func tagStrings() -> [String] {
        post.tags.map { $0 }.sorted()
    }

    private func createPostDate(_ post: Post) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "de_DE")
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: post.date!)
    }
    
    private func createPostUrl(_ post: Post?) -> String {
        guard let selectedPost = post else { return VnznEnv.baseUrl }
        var url = VnznEnv.baseUrl
        
        url.append(createDatePath(selectedPost))
        url.append(selectedPost.name.trimmingCharacters(in: .whitespacesAndNewlines))
        url.append("/")
        
        return url
    }
    
    private func createDatePath(_ post: Post) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "de_DE")
        dateFormatter.dateFormat = "yyyy/MM/dd/"
        return dateFormatter.string(from: post.date!)
    }

    private func boldText(_ text: String) -> Text {
        /*let integers = (0...3)
        _ = integers.publisher
                .sink { print("Received \($0)") }*/
        
        var attributedString = AttributedString(text + " ")
        attributedString.font = .body.bold()
        return Text(attributedString + attributedString)
    }
}



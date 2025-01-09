import SwiftUI

struct PhotoPosts: View {

    private let posts: [Post]

    @Environment(MetaData.self) var metaData: MetaData
    @Environment(Router.self) var router: Router

    @State private var tagItemPosts: [Post] = []

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    private let dataKey: String
    private let tagItemKey: String

    init(posts: [Post], dataKey: String, tagItemKey: String) {
        self.posts = posts
        self.dataKey = dataKey
        self.tagItemKey = tagItemKey
    }

    var body: some View {
        VStack {
            if tagItemPosts.count > 3 {
                Grid(horizontalSpacing: 30,
                     verticalSpacing: 30) {
                    GridRow {
                        PostImage(post: tagItemPosts[0])
                            .frame(width: 100, height: 100)
                        PostImage(post: tagItemPosts[1])
                            .frame(width: 100, height: 100)
                    }
                    GridRow {
                        PostImage(post: tagItemPosts[2])
                            .frame(width: 100, height: 100)
                        PostImage(post: tagItemPosts[3])
                            .frame(width: 100, height: 100)
                    }
                }
            }
        }
        .onTapGesture {
            if let tagItem = photoTagItem() {
                router.currentNavigationPath.append(NavigationTarget.tag(tagItem))
            }
        }
        .task {
            initPhotoPosts()
        }

    }

    private func initPhotoPosts() {
        if let data = UserDefaults.standard.data(forKey: dataKey) {
            do {
                let decoder = JSONDecoder()
                let loadedPostIndices = try decoder.decode(RandomPosts.self, from: data)
                let createdAt = Date(timeIntervalSince1970: loadedPostIndices.createdAt)
                if Date().noon > createdAt.noon {
                    try setNewPhotoPostsIndices()
                } else {
                    if let tagItem = photoTagItem() {
                        tagItemPosts.removeAll()
                        for loadedPostIndex in loadedPostIndices.posts {
                            tagItemPosts.append(tagItem.posts[loadedPostIndex])
                        }
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        } else {
            do {
                try setNewPhotoPostsIndices()
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    private func setNewPhotoPostsIndices() throws {
        if let tagItem = photoTagItem() {
            var indices = (0..<tagItem.posts.count).map { index in index }
            indices.shuffle()
            let newFacesPostsIndices = RandomPosts(createdAt: Date().timeIntervalSince1970, posts: indices)
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(newFacesPostsIndices)
            UserDefaults.standard.set(encodedData, forKey: dataKey)
            tagItemPosts.removeAll()
            for index in indices {
                tagItemPosts.append(tagItem.posts[index])
            }
        }
    }

    private func photoTagItem() -> TagItem? {
        metaData.serials.getTagItem(tagItemKey)
    }
}

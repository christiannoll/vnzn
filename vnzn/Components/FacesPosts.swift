import SwiftUI

struct FacesPosts: View {

    let posts: [Post]

    @Environment(MetaData.self) var metaData: MetaData
    @Environment(Router.self) var router: Router

    @State private var facesPosts: [Post] = []

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    init(posts: [Post]) {
        self.posts = posts
    }

    var body: some View {
        VStack {
            if facesPosts.count > 3 {
                Grid(horizontalSpacing: 30,
                     verticalSpacing: 30) {
                    GridRow {
                        PostImage(post: facesPosts[0])
                            .frame(width: 100, height: 100)
                        PostImage(post: facesPosts[1])
                            .frame(width: 100, height: 100)
                    }
                    GridRow {
                        PostImage(post: facesPosts[2])
                            .frame(width: 100, height: 100)
                        PostImage(post: facesPosts[3])
                            .frame(width: 100, height: 100)
                    }
                }
            }
        }
        .onTapGesture {
            if let tagItem = facesTagItem() {
                router.currentNavigationPath.append(NavigationTarget.tag(tagItem))
            }
        }
        .task {
            if metaData.serials.tagItems.isEmpty {
                await metaData.serials.createSerials(posts)
            }
            initFacesPosts()
        }

    }

    private func initFacesPosts() {
        if let data = UserDefaults.standard.data(forKey: "facesPosts") {
            do {
                let decoder = JSONDecoder()
                let loadedPostIndices = try decoder.decode(RandomPosts.self, from: data)
                let createdAt = Date(timeIntervalSince1970: loadedPostIndices.createdAt)
                if Date().noon > createdAt.noon {
                    try setNewFacesPostsIndices()
                } else {
                    if let tagItem = facesTagItem() {
                        facesPosts.removeAll()
                        for loadedPostIndex in loadedPostIndices.posts {
                            facesPosts.append(tagItem.posts[loadedPostIndex])
                        }
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        } else {
            do {
                try setNewFacesPostsIndices()
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    private func setNewFacesPostsIndices() throws {
        if let tagItem = facesTagItem() {
            var indices = (0..<tagItem.posts.count).map { index in index }
            indices.shuffle()
            let newFacesPostsIndices = RandomPosts(createdAt: Date().timeIntervalSince1970, posts: indices)
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(newFacesPostsIndices)
            UserDefaults.standard.set(encodedData, forKey: "facesPosts")
            facesPosts.removeAll()
            for index in indices {
                facesPosts.append(tagItem.posts[index])
            }
        }
    }

    private func facesTagItem() -> TagItem? {
        metaData.serials.getTagItem("Fotos: Gesichter")
    }
}

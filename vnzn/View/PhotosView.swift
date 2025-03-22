import SwiftUI

struct PhotosView: View {
    
    @State private var posts: [Post] = []
    @State private var orientation = UIDeviceOrientation.unknown

    @Environment(MetaData.self) var metaData: MetaData

    let columns = [
        GridItem(.adaptive(minimum: 220))
    ]

    var body: some View {
        Group {
            if orientation.isLandscape {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach (posts) { post in
                            PostRow(post: post)
                        }
                    }
                }
            } else {
                List {
                    ForEach (posts) { post in
                        PostRow(post: post)
                    }
                }
            }
        }
        .onRotate { newOrientation in
            orientation = newOrientation
        }
        .onAppear {
            if let tagItem = metaData.tags.getTagItem("Foto") {
                posts = tagItem.posts
            }
        }
        .navigationTitle("Fotos")
        .scrollContentBackground(.hidden)
    }
}


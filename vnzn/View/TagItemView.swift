import SwiftUI

struct TagItemView: View {
    
    let tagItem: TagItem
    @State private var orientation = UIDeviceOrientation.unknown

    let columns = [
        GridItem(.adaptive(minimum: 220))
    ]

    var body: some View {
        Group {
            if orientation.isLandscape && tagItem.isImageTag() {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach (tagItem.posts) { post in
                            PostRow(post: post)
                        }
                    }
                }
            } else {
                List {
                    ForEach (tagItem.posts) { post in
                        PostRow(post: post)
                    }
                }
            }
        }
        .onRotate { newOrientation in
            orientation = newOrientation
        }
        .navigationTitle(tagItem.key)
        .navigationBarTitleDisplayMode(.inline)
    }
}

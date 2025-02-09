import SwiftUI

struct PostImage: View {
    
    let post: Post
    
    var body: some View {
        /*AsyncImage(url: URL(string: VnznEnv.baseRootUrl + "images/" + post.data)) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else if phase.error != nil {
                Image(systemName: "photo")
                    .font(.title)
                    .foregroundStyle(.secondary)
            } else {
                ProgressView()
            }
        }*/

        if let imageData = post.image, let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}

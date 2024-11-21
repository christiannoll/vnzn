import SwiftUI

struct PostImage: View {
    
    let post: Post
    
    var body: some View {
        AsyncImage(url: URL(string: VnznEnv.baseUrl + "images/" + post.data)) { phase in
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
        }
    }
}

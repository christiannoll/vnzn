import SwiftUI

struct vnznWidgetView : View {

    let post: Post
    let nodeParser = NodeParser()
    let stringBuilder = StringBuilder()

    @Environment(\.widgetFamily) private var widgetFamily

    var body: some View {
        VStack {
            if post.type == .image {
                image(post: post)
            } else {
                text(post: post)
            }
        }
    }

    @ViewBuilder
    private func image(post: Post) -> some View {
        if let url = URL(string: VnznEnv.baseRootUrl + "images/" + post.data),
           let imageData = try? Data(contentsOf: url),
           let uiImage = UIImage(data: imageData) {
            Text("v.n.z.n")
                .foregroundStyle(.blue)
                .padding(.top, 6)
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
            Text(Date.createPostDate(post))
                .foregroundStyle(.secondary)
                .font(.subheadline)
            Spacer()
        }
    }

    @ViewBuilder
    private func text(post: Post) -> some View {
        if widgetFamily == .systemSmall {
            smallText(post: post)
        } else {
            largeText(post: post)
        }
    }

    @ViewBuilder
    private func smallText(post: Post) -> some View {
        VStack(alignment: .leading) {
            Text("v.n.z.n")
                .foregroundStyle(.blue)
                .padding(.bottom, 20)
            Text(post.title)
                .padding(.bottom, 10)
            Text(Date.createPostDate(post))
                .foregroundStyle(.secondary)
                .font(.subheadline)
        }
    }

    @ViewBuilder
    private func largeText(post: Post) -> some View {
        VStack(alignment: .leading) {
            Text("v.n.z.n")
                .foregroundStyle(.blue)
                .padding(.bottom, 20)
            Text(post.title)
                .padding(.bottom, 10)
            ForEach(nodeParser.parse(postExcerpt(post)), id: \.self) { nodes in
                if case .curlybraces(_) = nodes.first {
                    Text(stringBuilder.parse(nodes, post))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 4)
                } else {
                    Text(stringBuilder.parse(nodes, post))
                        .multilineTextAlignment(.leading)
                }
            }
            .padding(.bottom, 10)
            Text(Date.createPostDate(post))
                .foregroundStyle(.secondary)
                .font(.subheadline)
            Spacer()
        }
    }

    private func postExcerpt(_ post: Post) -> String {
        let text = post.data
        /*if text.components(separatedBy: "\t* ").count > 3 {
            return text.components(separatedBy: "\t* ").prefix(3).joined(separator: "\t* ") + "\n..."
        }*/
        var excerpt = text.split(separator: "\t").first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if excerpt != text {
            excerpt += "\n..."
        }
        return excerpt
    }
}

import SwiftUI
import SwiftData

struct MetaView: View {

    @Environment(Serials.self) var serials: Serials
    @Query(sort: \Post.date, order: .reverse) var posts: [Post]

    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            List {
                Button {
                    path.append(NavigationTarget.serials)
                } label: {
                    Text("Serien")
                }
            }
            .task {
                if serials.tagItems.isEmpty {
                    await serials.createSerials(posts)
                }
            }
            .navigationDestination(for: NavigationTarget.self) { navState in
                if case .serials = navState {
                    SerialsView(path: $path, serials: serials)
                }
            }
            .navigationTitle("Meta")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

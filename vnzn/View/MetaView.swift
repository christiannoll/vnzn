import SwiftUI
import SwiftData

struct MetaView: View {

    @Environment(Router.self) var router: Router
    @Environment(Serials.self) var serials: Serials
    @Query(sort: \Post.date, order: .reverse) var posts: [Post]

    @State private var path = NavigationPath()

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $path) {
            List {
                Button {
                    path.append(NavigationState.serials)
                } label: {
                    Text("Serien")
                }
            }
            .task {
                if serials.tagItems.isEmpty {
                    await serials.createSerials(posts)
                }
            }
            .navigationDestination(for: NavigationState.self) { navState in
                if case .serials = navState {
                    SerialsView(path: $path, serials: serials)
                }
            }
            .navigationTitle("Meta")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

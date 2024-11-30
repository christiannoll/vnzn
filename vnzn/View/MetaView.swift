import SwiftUI
import SwiftData

struct MetaView: View {

    @Environment(Router.self) var router: Router
    @Environment(Serials.self) var serials: Serials
    @Query(sort: \Post.date, order: .reverse) var posts: [Post]

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.metaNavigationPath) {
            List {
                Button {
                    router.metaNavigationPath.append(.serials)
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
                    SerialsView(serials: serials)
                }
            }
            .navigationTitle("Meta")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

import SwiftUI
import SwiftData

struct DiscoverView: View {

    @Query(sort: \Post.date) var posts: [Post]
    @Environment(Serials.self) var serials: Serials
    @Environment(Router.self) var router: Router

    @State private var settingsVisible = false

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.discoverViewNavigationPath) {
            List {
                Section("Post des Tages") {
                    PostOfTheDay(posts: posts)
                }
                .listRowSeparator(.hidden)
                Section("Fotoserie: Gesichter") {
                    FacesPosts(posts: posts)
                }
                .listRowSeparator(.hidden)
            }
            .environment(\.defaultMinListHeaderHeight, 0)
            .selectNavigationDestination()
            .navigationTitle("Entdecken")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    VStack {
                        Button {
                            settingsVisible.toggle()
                        } label: {
                            Image(systemName: "gearshape")
                                .foregroundStyle(Color.accentColor)
                        }
                        Spacer()
                    }
                    .padding(.trailing, 16)
                }
            }
            .toolbarBackground(.visible, for: .tabBar)
            .sheet(isPresented: $settingsVisible) {
                SettingsView()
            }
        }
    }
}

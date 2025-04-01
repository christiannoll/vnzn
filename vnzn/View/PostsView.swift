import SwiftUI
import SwiftData
import Combine

@MainActor
class ListViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var filteredItems: [Post] = []

    var posts: [Post] = []

    private var cancellable: AnyCancellable?

    init() {
        do {
            let postFetchDescriptor = FetchDescriptor<Post>(sortBy: [ SortDescriptor(\.date, order: .reverse)])
            posts = try SwiftDataService.shared.context.fetch(postFetchDescriptor)

            $searchText
                .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main) // Vermeidet ständiges Updaten
                .removeDuplicates()
                .map { searchText in
                    searchText.isEmpty ? self.posts : self.posts.filter { $0.data.localizedCaseInsensitiveContains(searchText) }
                }
                .assign(to: &$filteredItems)
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct PostsView: View {

    @StateObject private var viewModel = ListViewModel()

    @State private var onlyFavourites = false
    @State private var settingsVisible = false

    @Environment(MetaData.self) var metaData: MetaData
    @Environment(Router.self) var router: Router
    @Query(sort: \Post.date, order: .reverse) var posts: [Post]

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.postsViewNavigationPath) {
            List {
                ForEach (viewModel.filteredItems.filter { shouldInclude($0) }) { post in
                    PostRow(post: post)
                }
            }
            .autocorrectionDisabled()
            .selectNavigationDestination()
            .searchable(text: $viewModel.searchText, prompt: "vnzn durchsuchen")
            .scrollContentBackground(.hidden)
            .navigationTitle("v.n.z.n")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarTitleTextColor(.blue)
            .refreshable {
                Task {
                    let updateService = UpdateService()
                    try await updateService.fetchUpdates(modelContext: SwiftDataService.shared.context)
                }
            }
            .task {
                if metaData.tags.tagItems.isEmpty {
                    await metaData.tags.createTags(viewModel.posts)
                }
                if metaData.index.indexItems.isEmpty {
                    await metaData.index.createIndex(viewModel.posts)
                }
                if metaData.serials.tagItems.isEmpty {
                    await metaData.serials.createSerials(viewModel.posts)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        onlyFavourites.toggle()
                    } label: {
                        Image(systemName: onlyFavourites ? "star.fill" : "star")
                            .foregroundStyle(Color.accentColor)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        settingsVisible.toggle()
                    } label: {
                        Image(systemName: "gearshape")
                            .foregroundStyle(Color.accentColor)
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
    
    private func shouldInclude(_ post: Post) -> Bool {
        if onlyFavourites && !post.isFavourite {
            return false
        }
        return true
    }
}

extension View {
    @available(iOS 14, *)
    func navigationBarTitleTextColor(_ color: Color) -> some View {
        let uiColor = UIColor(color)
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor ]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor ]
        return self
    }
}

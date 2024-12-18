import SwiftUI
import SwiftData

struct MoviesView: View {

    @Query(sort: \Post.date) var posts: [Post]
    @Environment(Router.self) var router: Router
    @Environment(MoviesRegister.self) var movies: MoviesRegister

    var body: some View {
        List {
            ForEach(movies.register.registerItems, id: \.self) { item in
                Text(item.content)
                    .bold()
                ForEach(item.posts, id: \.self) { post in
                    Button {
                        router.currentNavigationPath.append(NavigationTarget.post(post))
                    } label: {
                        HStack {
                            Text(post.title)
                                .foregroundStyle(.secondary)
                            Spacer()
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .task {
            if movies.register.registerItems.isEmpty {
                await movies.createMoviesRegister(posts)
            }
        }
        .navigationTitle("Filme")
        .navigationBarTitleDisplayMode(.inline)
    }
}

import SwiftUI
import SwiftData

struct BooksView: View {

    @Query(sort: \Post.date) var posts: [Post]
    @Environment(Router.self) var router: Router
    @Environment(BooksRegister.self) var books: BooksRegister

    var body: some View {
        List {
            ForEach(books.register.registerItems, id: \.self) { item in
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
            if books.register.registerItems.isEmpty {
                await books.createBooksRegister(posts)
            }
        }
        .navigationTitle("Bücher")
        .navigationBarTitleDisplayMode(.inline)
    }
}

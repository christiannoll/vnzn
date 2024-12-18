import SwiftUI
import SwiftData

struct PersonsView: View {

    @Query(sort: \Post.date) var posts: [Post]
    @Environment(Router.self) var router: Router
    @Environment(PersonsRegister.self) var persons: PersonsRegister

    var body: some View {
        List {
            ForEach(persons.register.registerItems, id: \.self) { item in
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
            if persons.register.registerItems.isEmpty {
                await persons.createPersonsRegister(posts)
            }
        }
        .navigationTitle("Personen")
        .navigationBarTitleDisplayMode(.inline)
    }
}

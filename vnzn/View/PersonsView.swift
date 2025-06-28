import SwiftUI
import SwiftData

struct PersonsView: View {

    @Query(sort: \Post.date) var posts: [Post]
    @Environment(Router.self) var router: Router
    @Environment(MetaData.self) var metaData: MetaData

    var body: some View {
        List {
            ForEach(metaData.persons.register.registerItems, id: \.self) { item in
                Text(item.content)
                    .bold()
                ForEach(item.posts, id: \.self) { post in
                    Button {
                        router.currentNavigationPath.append(NavigationTarget.post(post, posts))
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
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("sortDown", systemImage: "chevron.down") {
                    metaData.persons.register.registerItems.sort()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("sortUp", systemImage: "chevron.up") {
                    metaData.persons.register.registerItems.sort(by: >)
                }
            }
        }
        .task {
            if metaData.persons.register.registerItems.isEmpty {
                await metaData.persons.createPersonsRegister(posts)
            }
        }
        .navigationTitle("Personen")
        .navigationBarTitleDisplayMode(.inline)
    }
}

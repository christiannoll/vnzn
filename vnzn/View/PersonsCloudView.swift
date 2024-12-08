import SwiftUI
import SwiftData

struct PersonsCloudView: View {

    @Query(sort: \Post.date) var posts: [Post]
    @Environment(Router.self) var router: Router
    @Environment(PersonsRegister.self) var persons: PersonsRegister

    let columns = [
        GridItem(.adaptive(minimum: 140))
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(persons.register.registerItems, id: \.self) { item in
                if item.numberOfPosts > 1 {
                    Button {
                        router.currentNavigationPath.append(NavigationTarget.person(item))
                    } label: {
                        Text(item.getStyleAttributeText())
                    }
                }
            }
        }
        .padding(20)
        .task {
            if persons.register.registerItems.isEmpty {
                await persons.createPersonsRegister(posts)
            }
        }
        .navigationTitle("Personenwolke")
        .navigationBarTitleDisplayMode(.inline)
    }
}

import SwiftUI
import SwiftData

struct PersonsCloudView: View {

    @Query(sort: \Post.date) var posts: [Post]
    @Environment(Router.self) var router: Router
    @Environment(MetaData.self) var metaData: MetaData

    let columns = [
        GridItem(.adaptive(minimum: 140))
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(metaData.persons.register.registerItems, id: \.self) { item in
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
                if metaData.persons.register.registerItems.isEmpty {
                    await metaData.persons.createPersonsRegister(posts)
                }
            }
            .navigationTitle("Personenwolke")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

import SwiftUI
import SwiftData

struct TopicsCloudView: View {

    @Query(sort: \Post.date) var posts: [Post]
    @Environment(Router.self) var router: Router
    @Environment(IndexRegister.self) var indices: IndexRegister

    let columns = [
        GridItem(.adaptive(minimum: 140))
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(indices.register.registerItems, id: \.self) { item in
                    if item.numberOfPosts > 1 {
                        Button {
                            router.currentNavigationPath.append(NavigationTarget.topic(item))
                        } label: {
                            Text(item.getStyleAttributeText())
                        }
                    }
                }
            }
            .padding(20)
            .task {
                if indices.register.registerItems.isEmpty {
                    await indices.createIndexRegister(posts)
                }
            }
            .navigationTitle("Themenwolke")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

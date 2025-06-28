import SwiftUI
import SwiftData

struct TimelineView: View {

    @Query(sort: \Post.date) var posts: [Post]
    @Environment(Router.self) var router: Router
    @Environment(MetaData.self) var metaData: MetaData

    var body: some View {
        List {
            ForEach(metaData.timeline.timelineItems, id: \.self) { item in
                Text(String(item.year))
                    .bold()
                ForEach(item.posts, id: \.self) { post in
                    HStack {
                        Text(post.title)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        router.currentNavigationPath.append(NavigationTarget.post(post, posts))
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("sortDown", systemImage: "chevron.down") {
                    metaData.timeline.timelineItems.sort()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("sortUp", systemImage: "chevron.up") {
                    metaData.timeline.timelineItems.sort(by: >)
                }
            }
        }
        .task {
            if metaData.timeline.timelineItems.isEmpty {
                await metaData.timeline.createTimeline(posts)
            }
        }
        .navigationTitle("Timeline")
        .navigationBarTitleDisplayMode(.inline)
    }
}

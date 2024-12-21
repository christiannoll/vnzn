import SwiftUI
import SwiftData

struct TimelineView: View {

    @Query(sort: \Post.date) var posts: [Post]
    @Environment(Router.self) var router: Router
    @Environment(Timeline.self) var timeline: Timeline

    var body: some View {
        List {
            ForEach(timeline.timelineItems, id: \.self) { item in
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
                        router.currentNavigationPath.append(NavigationTarget.post(post))
                    }
                }
            }
        }
        .task {
            if timeline.timelineItems.isEmpty {
                await timeline.createTimeline(posts)
            }
        }
        .navigationTitle("Timeline")
        .navigationBarTitleDisplayMode(.inline)
    }
}

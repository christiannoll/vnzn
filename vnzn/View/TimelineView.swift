import SwiftUI
import SwiftData

struct TimelineView: View {

    @Binding var path: NavigationPath
    @Query(sort: \Post.date) var posts: [Post]
    @Environment(Timeline.self) var timeline: Timeline

    var body: some View {
        List {
            ForEach(timeline.timelineItems, id: \.self) { item in
                Text(String(item.year))
                    .bold()
                ForEach(item.posts, id: \.self) { post in
                    Button {
                        path.append(NavigationTarget.post(post))
                    } label: {
                        Text(post.title)
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

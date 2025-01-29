import WidgetKit
import SwiftUI
import SwiftData

struct Provider: TimelineProvider {

    var modelContainer: ModelContainer?

    init() {
            self.modelContainer = try? ModelContainer(for: Post.self)
        }

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), post: Post())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), post: Post())
        completion(entry)
    }

    @MainActor
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []


        var post = Post()

        if let modelContainer {
            var postFetchDescriptor = FetchDescriptor<Post>(sortBy: [ SortDescriptor(\.date, order: .reverse)])
            postFetchDescriptor.fetchLimit = 1
            if let loadedPosts = try? modelContainer.mainContext.fetch(postFetchDescriptor) {
                if loadedPosts.isEmpty == false {
                    post = loadedPosts[0]

                    // Generate a timeline consisting of five entries an hour apart, starting from the current date.
                    let currentDate = Date()
                    for hourOffset in 0 ..< 5 {
                        let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
                        let entry = SimpleEntry(date: entryDate, post: post)
                        entries.append(entry)
                    }
                }
            }
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let post: Post
}

struct vnznWidgetEntryView : View {

    let entry: Provider.Entry

    var body: some View {
        vnznWidgetView(post: entry.post)
    }
}

struct vnznWidget: Widget {
    let kind: String = "vnznWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                vnznWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                vnznWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    vnznWidget()
} timeline: {
    SimpleEntry(date: .now, post: Post())
    SimpleEntry(date: .now, post: Post())
}

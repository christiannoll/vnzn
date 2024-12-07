import SwiftUI
import SwiftData

struct StatisticsView: View {

    @Binding var path: NavigationPath
    @Query(sort: \Post.date) var posts: [Post]
    @Environment(SiteStatistics.self) var statistics: SiteStatistics

    var body: some View {
        List {
            Section {
                Text("Anzahl an Posts: \(statistics.data.numberOfPosts)")
                Text("Anzahl davon Bilder: \(statistics.data.numberOfImages)")
                Text("Index: \(statistics.data.numberOfIndexItems)")
                Text("Kategorien: \(statistics.data.numberOfTagItems)")
                Text("Serien: \(statistics.data.numberOfSerialItems)")
                Text("Links: \(statistics.data.numberOfAllLinks)")
            }
            Section {
                Text("Durchschnittliche Anzahl an Links: \(statistics.data.meanNumberOfLinks)")
                Text("Durchschnittliche Anzahl an Wörtern: \(statistics.data.meanNumberOfWords)")
            }
            Section {
                HStack {
                    Text("Post mit den meisten Wörtern \(statistics.data.maxWordCountPostItem?.number ?? 0): ")
                    Button {
                        if let item = statistics.data.maxWordCountPostItem {
                            path.append(NavigationTarget.post(item.post))
                        }
                    } label: {
                        Text("\(statistics.data.maxWordCountPostItem?.post.title ?? "")")
                    }
                }
                HStack {
                    Text("Post mit den wenigsten Wörtern \(statistics.data.minWordCountPostItem?.number ?? 0): ")
                    Button {
                        if let item = statistics.data.minWordCountPostItem {
                            path.append(NavigationTarget.post(item.post))
                        }
                    } label: {
                        Text("\(statistics.data.minWordCountPostItem?.post.title ?? "")")
                    }
                }
                HStack {
                    Text("Post mit den meisten Links \(statistics.data.maxLinkCountPostItem?.number ?? 0): ")
                    Button {
                        if let item = statistics.data.maxLinkCountPostItem {
                            path.append(NavigationTarget.post(item.post))
                        }
                    } label: {
                        Text("\(statistics.data.maxLinkCountPostItem?.post.title ?? "")")
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
        .navigationTitle("Statistik")
        .navigationBarTitleDisplayMode(.inline)
        Spacer()
    }
}


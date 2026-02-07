import SwiftUI
import SwiftData

struct StatisticsView: View {

    @Query(sort: \Post.date) var posts: [Post]
    @Environment(Router.self) var router: Router
    @Environment(MetaData.self) var metaData: MetaData
    @Environment(SiteStatistics.self) var statistics: SiteStatistics

    var body: some View {
        List {
            Section {
                StatisticTextItem(title: "Anzahl an Posts:", value: statistics.data.numberOfPosts)
                StatisticTextItem(title: "Anzahl davon Bilder:", value: statistics.data.numberOfImages)
                StatisticTextItem(title: "Index:", value: statistics.data.numberOfIndexItems)
                StatisticTextItem(title: "Kategorien:", value: statistics.data.numberOfTagItems)
                StatisticTextItem(title: "Serien:", value: statistics.data.numberOfSerialItems)
                StatisticTextItem(title: "Links:", value: statistics.data.numberOfAllLinks)
            }
            Section {
                StatisticTextItem(title: "Durchschnittliche Anzahl an Links:", value: statistics.data.meanNumberOfLinks)
                StatisticTextItem(title: "Durchschnittliche Anzahl an Wörtern:", value: statistics.data.meanNumberOfWords)
            }
            Section {
                HStack {
                    Text("Post mit den meisten Wörtern \(statistics.data.maxWordCountPostItem?.number ?? 0): ")
                    Spacer()
                    Button {
                        if let item = statistics.data.maxWordCountPostItem {
                            router.currentNavigationPath.append(NavigationTarget.post(item.post, posts))
                        }
                    } label: {
                        Text("\(statistics.data.maxWordCountPostItem?.post.title ?? "")")
                    }
                }
                HStack {
                    Text("Post mit den wenigsten Wörtern \(statistics.data.minWordCountPostItem?.number ?? 0): ")
                    Spacer()
                    Button {
                        if let item = statistics.data.minWordCountPostItem {
                            router.currentNavigationPath.append(NavigationTarget.post(item.post, posts))
                        }
                    } label: {
                        Text("\(statistics.data.minWordCountPostItem?.post.title ?? "")")
                    }
                }
                HStack {
                    Text("Post mit den meisten Links \(statistics.data.maxLinkCountPostItem?.number ?? 0): ")
                    Spacer()
                    Button {
                        if let item = statistics.data.maxLinkCountPostItem {
                            router.currentNavigationPath.append(NavigationTarget.post(item.post, posts))
                        }
                    } label: {
                        Text("\(statistics.data.maxLinkCountPostItem?.post.title ?? "")")
                    }
                }
                HStack {
                    Text("Post mit den meisten Besuchen \(statistics.data.maxVisitsPostItem?.number ?? 0): ")
                    Spacer()
                    Button {
                        if let item = statistics.data.maxVisitsPostItem {
                            router.currentNavigationPath.append(NavigationTarget.post(item.post, posts))
                        }
                    } label: {
                        Text("\(statistics.data.maxVisitsPostItem?.post.title ?? "")")
                    }
                }
            }
        }
        .task {
            if statistics.data.numberOfPosts == 0 {
                await statistics.createStatistics(posts, index: metaData.index, tags: metaData.tags, serials: metaData.serials)
            }
        }
        .navigationTitle("Statistik")
    }
}

struct StatisticTextItem: View {

    let title: LocalizedStringKey
    let value: Int

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(String(value))
                .foregroundStyle(.secondary)
        }
    }
}


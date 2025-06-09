import Foundation
import SwiftData

class UpdateService {
    
    let contentParser = ContentParser()
    var loadedPosts: [Post] = []
    var fetchedHistoryItems: [HistoryItem] = []

    static let lastUpdateKey = "lastUpdate"

    //@MainActor
    func fetchUpdates(modelContext: ModelContext, _ languageChanged: Bool = false) async throws {
        let lastUpdateFromServer = await fetchLastUpdate()

        let lastUpdateLocal = UserDefaults.standard.double(forKey: Self.lastUpdateKey)
        if lastUpdateFromServer > lastUpdateLocal || languageChanged {
            let updateService = UpdateService()
            try await updateService.update(modelContext, languageChanged)
            UserDefaults.standard.set(lastUpdateFromServer, forKey: Self.lastUpdateKey)
        }
    }

    //@MainActor
    private func update(_ modelContext:  ModelContext, _ languageChanged: Bool) async throws {
        let items = await fetchItems(fromUrl: VnznEnv.baseUrl + "xml/content.xml")

        if languageChanged == false {
            let postFetchDescriptor = FetchDescriptor<Post>()
            loadedPosts = try modelContext.fetch(postFetchDescriptor)

            let historyItemFetchDescriptor = FetchDescriptor<HistoryItem>()
            fetchedHistoryItems = try modelContext.fetch(historyItemFetchDescriptor)

            try modelContext.delete(model: Post.self)
            try modelContext.delete(model: HistoryItem.self)
        }

        var newPosts: [Post] = []

        for item in items.reversed() {
            var isFavourite = false
            var visits: Int = 0
            var image: Data? = nil
            if let loadedPost = loadedPost(item) {
                isFavourite = loadedPost.isFavourite
                visits = loadedPost.visits
                image = loadedPost.image
            }
            if item.itemType() == .image && image == nil {
                image = await fetchImageData(item: item)
            }
            let post = Post(id: item.id, data: item.data, name: item.name, title: item.title, date: item.date, tags: item.tags, indices: item.indices, serials: item.serials, links: item.links, years: item.years, persons: item.persons, movies: item.movies, books: item.books, type: item.postType(), textFormat: item.textFormat(), isFavourite: isFavourite, visits: visits, image: image)
            modelContext.insert(post)
            newPosts.append(post)
        }

        for fetchedHistoryItem in fetchedHistoryItems {
            if let post = newPosts.first(where: { $0.id == fetchedHistoryItem.post.id }) {
                modelContext.insert(HistoryItem(date: fetchedHistoryItem.date, post: post))
            }
        }

        try modelContext.save()
        await NotificationCenter.post(.fetchPosts)
    }

    private func fetchImageData(item: Item) async -> Data? {
        let urlString = VnznEnv.baseRootUrl + "images/" + item.data
        return await Client().fetchRawData(fromURL: urlString)
    }

    private func fetchItems(fromUrl: String) async -> [Item] {
        do {
            let xmlString = try await Client().fetchData(fromUrl: fromUrl)
            let items = contentParser.parse(xmlString: xmlString)
            return items
        } catch {
            print(error)
            return []
        }
    }
    
    private func loadedPost(_ item: Item) -> Post? {
        loadedPosts.first  { $0.id == item.id }
    }
}

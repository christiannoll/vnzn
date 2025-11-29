import Foundation
import SwiftData

@MainActor
class UpdateService {
    
    let contentParser = ContentParser()
    var loadedPosts: [Post] = []
    var fetchedHistoryItems: [HistoryItem] = []
    var fetchedSearchItems: [SearchItem] = []

    static let lastUpdateKey = "lastUpdate"
    static let lastFullSyncKey = "lastFullSync"

    func fetchUpdates(modelContext: ModelContext, _ languageChanged: Bool = false) async throws {
        let lastUpdateFromServer = await fetchLastUpdate()
        let lastFullSyncFromServer = await fetchLastFullSync()

        let lastUpdateLocal = UserDefaults.standard.double(forKey: Self.lastUpdateKey)
        let lastFullSyncLocal = UserDefaults.standard.double(forKey: Self.lastFullSyncKey)

        if lastUpdateFromServer > lastUpdateLocal || languageChanged {
            let updateService = UpdateService()
            if lastFullSyncFromServer > lastFullSyncLocal || languageChanged {
                try await updateService.fullSync(modelContext, languageChanged)
                UserDefaults.standard.set(lastFullSyncFromServer, forKey: Self.lastFullSyncKey)
            } else {
                try await updateService.update(modelContext)
            }
            UserDefaults.standard.set(lastUpdateFromServer, forKey: Self.lastUpdateKey)
        } else {
            NotificationCenter.post(.fetchPosts)
        }
    }

    private func update(_ modelContext: ModelContext) async throws {
        let items = await fetchItems(fromUrl: VnznEnv.baseUrl + "xml/content.xml")

        let postFetchDescriptor = FetchDescriptor<Post>()
        loadedPosts = try modelContext.fetch(postFetchDescriptor)

        var newPosts: [Post] = []

        for item in items.reversed() {
            if loadedPost(item) == nil {
                var image: Data? = nil

                if item.itemType() == .image && image == nil {
                    image = await fetchImageData(item: item)
                }
                let post = Post(id: item.id, data: item.data, name: item.name, title: item.title, date: item.date, tags: item.tags, indices: item.indices, serials: item.serials, links: item.links, years: item.years, persons: item.persons, movies: item.movies, books: item.books, type: item.postType(), textFormat: item.textFormat(), isFavourite: false, visits: 0, image: image)
                modelContext.insert(post)
                newPosts.append(post)
            }
        }

        try modelContext.save()
        NotificationCenter.post(.fetchPosts)
    }

    private func fullSync(_ modelContext:  ModelContext, _ languageChanged: Bool) async throws {
        let items = await fetchItems(fromUrl: VnznEnv.baseUrl + "xml/content.xml")

        if languageChanged == false {
            let postFetchDescriptor = FetchDescriptor<Post>()
            loadedPosts = try modelContext.fetch(postFetchDescriptor)

            let historyItemFetchDescriptor = FetchDescriptor<HistoryItem>()
            fetchedHistoryItems = try modelContext.fetch(historyItemFetchDescriptor)

            let searchItemFetchDescriptor = FetchDescriptor<SearchItem>()
            fetchedSearchItems = try modelContext.fetch(searchItemFetchDescriptor)

            try modelContext.delete(model: Post.self)
            try modelContext.delete(model: HistoryItem.self)
            try modelContext.delete(model: SearchItem.self)
        }

        var newPosts: [Post] = []

        for item in items.reversed() {
            var isFavourite = false
            var visits: Int = 0
            var image: Data? = nil
            if let loadedPost = loadedPost(item) {
                isFavourite = loadedPost.isFavourite
                visits = loadedPost.visits
                //image = loadedPost.image
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

        for fetchedSearchItem in fetchedSearchItems {
            if let post = newPosts.first(where: { $0.id == fetchedSearchItem.post.id }) {
                modelContext.insert(SearchItem(date: fetchedSearchItem.date, searchTerm: fetchedSearchItem.searchTerm, post: post))
            }
        }

        try modelContext.save()
        NotificationCenter.post(.fetchPosts)
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

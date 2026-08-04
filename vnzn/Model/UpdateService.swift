import Foundation
import SwiftData
import OSLog

final class UpdateService {

    private let contentParser = ContentParser()
    private let logger = Logger(subsystem: "de.vnzn.vnzn", category: "UpdateService")

    static let lastUpdateKey = "lastUpdate"
    static let lastFullSyncKey = "lastFullSync"

    func fetchUpdates(modelContext: ModelContext, _ languageChanged: Bool = false) async throws {
        // observe whether it is truly necessary or merely a rare exception
        //try await repairMissingImages(modelContext: modelContext)
        
        async let update = Client.shared.fetchLastUpdate()
        async let fullSync = Client.shared.fetchLastFullSync()

        let (lastUpdateFromServer, lastFullSyncFromServer) = await (update, fullSync)

        let lastUpdateLocal = UserDefaults.standard.double(forKey: Self.lastUpdateKey)
        let lastFullSyncLocal = UserDefaults.standard.double(forKey: Self.lastFullSyncKey)

        guard lastUpdateFromServer > lastUpdateLocal || languageChanged else {
            await MainActor.run {
                NotificationCenter.post(.fetchPosts)
            }
            return
        }

        if lastFullSyncFromServer > lastFullSyncLocal || languageChanged {
            do {
                try await fullSyncFlow(modelContext: modelContext)
                UserDefaults.standard.set(lastFullSyncFromServer, forKey: Self.lastFullSyncKey)
            } catch {
                logger.error("fullSyncFlow error: \(error)")
                throw error
            }
        } else {
            do {
                try await incrementalUpdate(modelContext: modelContext)
            } catch {
                logger.error("incrementalUpdate error: \(error)")
                throw error
            }
        }

        UserDefaults.standard.set(lastUpdateFromServer, forKey: Self.lastUpdateKey)
    }

    private func incrementalUpdate(modelContext: ModelContext) async throws {
        let items = try await fetchItems()

        let existingIds: Set<Int> = try await MainActor.run {
            let posts = try modelContext.fetch(FetchDescriptor<Post>())
            return Set(posts.map { $0.id })
        }

        var newItems: [(item: Item, image: Data?)] = []

        for item in items where !existingIds.contains(item.id) {
            let image = await fetchImageIfNeeded(item)
            newItems.append((item, image))
        }

        try await MainActor.run {
            for (item, image) in newItems {
                let post = createPost(from: item, image: image)
                modelContext.insert(post)
            }

            try modelContext.save()
            NotificationCenter.post(.fetchPosts)
        }
    }

    private func fullSyncFlow(modelContext: ModelContext) async throws {
        let items = try await fetchItems()
        let imageMap = await prefetchImages(items)

        let oldData = try await MainActor.run {
            let posts = try modelContext.fetch(FetchDescriptor<Post>())
            let history = try modelContext.fetch(FetchDescriptor<HistoryItem>())
            let search = try modelContext.fetch(FetchDescriptor<SearchItem>())

            let postData = posts.map {
                (id: $0.id, isFavourite: $0.isFavourite, visits: $0.visits, image: $0.image)
            }

            let historyData = history.map {
                (date: $0.date, postId: $0.post.id)
            }

            let searchData = search.map {
                (date: $0.date, term: $0.searchTerm, postId: $0.post.id)
            }

            return (postData, historyData, searchData)
        }

        let oldPostMap = Dictionary(uniqueKeysWithValues:
            oldData.0.map { ($0.id, $0) }
        )

        try await MainActor.run {
            try modelContext.delete(model: HistoryItem.self)
            try modelContext.delete(model: SearchItem.self)
            try modelContext.delete(model: Post.self)

            try modelContext.save()

            var newPostsById: [Int: Post] = [:]

            for item in items.reversed() {
                let old = oldPostMap[item.id]

                let post = Post(
                    id: item.id,
                    data: item.data,
                    name: item.name,
                    title: item.title,
                    date: item.date,
                    tags: item.tags,
                    indices: item.indices,
                    serials: item.serials,
                    links: item.links,
                    years: item.years,
                    persons: item.persons,
                    movies: item.movies,
                    books: item.books,
                    type: item.postType(),
                    textFormat: item.textFormat(),
                    isFavourite: old?.isFavourite ?? false,
                    visits: old?.visits ?? 0,
                    image: imageMap[item.id] ?? old?.image
                )

                modelContext.insert(post)
                newPostsById[item.id] = post
            }

            try modelContext.save()

            for old in oldData.1 {
                if let post = newPostsById[old.postId] {
                    modelContext.insert(HistoryItem(date: old.date, post: post))
                }
            }

            for old in oldData.2 {
                if let post = newPostsById[old.postId] {
                    modelContext.insert(SearchItem(
                        date: old.date,
                        searchTerm: old.term,
                        post: post
                    ))
                }
            }

            try modelContext.save()
            NotificationCenter.post(.fetchPosts)
        }
    }

    private func fetchItems() async throws -> [Item] {
        do {
            let xml = try await Client.shared.fetchData(fromUrl: VnznEnv.baseUrl + "xml/content.xml")
            return contentParser.parse(xmlString: xml)
        } catch {
            logger.error("Fetch items error: \(error)")
            throw error
        }
    }

    private func fetchImageIfNeeded(_ item: Item) async -> Data? {
        guard item.itemType() == .image else { return nil }
        return await fetchImageData(item: item)
    }

    private func prefetchImages(_ items: [Item]) async -> [Int: Data] {
        var result: [Int: Data] = [:]

        await withTaskGroup(of: (Int, Data?).self) { group in
            for item in items where item.itemType() == .image {
                group.addTask {
                    let data = await self.fetchImageData(item: item)
                    return (item.id, data)
                }
            }

            for await (id, data) in group {
                if let data {
                    result[id] = data
                }
            }
        }
        return result
    }

    private func fetchImageData(item: Item) async -> Data? {
        let url = VnznEnv.baseRootUrl + "images/" + item.data
        return await Client.shared.fetchRawData(fromURL: url)
    }

    private func createPost(from item: Item, image: Data?) -> Post {
        Post(
            id: item.id,
            data: item.data,
            name: item.name,
            title: item.title,
            date: item.date,
            tags: item.tags,
            indices: item.indices,
            serials: item.serials,
            links: item.links,
            years: item.years,
            persons: item.persons,
            movies: item.movies,
            books: item.books,
            type: item.postType(),
            textFormat: item.textFormat(),
            isFavourite: false,
            visits: 0,
            image: image
        )
    }
    
    private func repairMissingImages(modelContext: ModelContext) async throws {
        let imageType = PostType.image
        
        let postsNeedingImage: [(id: Int, data: String)] = try await MainActor.run {
            let descriptor = FetchDescriptor<Post>(
                predicate: #Predicate { $0.type == imageType && $0.image == nil }
            )
            return try modelContext.fetch(descriptor).map { ($0.id, $0.data) }
        }

        guard !postsNeedingImage.isEmpty else { return }

        var fetched: [(id: Int, image: Data)] = []
        for post in postsNeedingImage {
            let url = VnznEnv.baseRootUrl + "images/" + post.data
            if let image = await Client.shared.fetchRawData(fromURL: url) {
                fetched.append((post.id, image))
            }
        }

        guard !fetched.isEmpty else { return }

        try await MainActor.run {
            let idsToUpdate = Set(fetched.map { $0.id })
            let descriptor = FetchDescriptor<Post>(predicate: #Predicate { idsToUpdate.contains($0.id) })
            let imageById = Dictionary(uniqueKeysWithValues: fetched)
            for post in try modelContext.fetch(descriptor) {
                post.image = imageById[post.id]
            }
            try modelContext.save()
        }
    }
}

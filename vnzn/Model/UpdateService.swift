import Foundation
import SwiftData

class UpdateService {
    
    let contentParser = ContentParser()
    var loadedPosts: [Post] = []
    
    @MainActor
    func update(container: ModelContainer) async throws {
        let items = await fetchItems(fromUrl: VnznEnv.baseUrl + "xml/content.xml")
        
        let postFetchDescriptor = FetchDescriptor<Post>()
        loadedPosts = try container.mainContext.fetch(postFetchDescriptor)
        
        for item in items {
            var isFavourite = false
            if let loadedPost = loadedPost(item) {
                isFavourite = loadedPost.isFavourite
            }
            let post = Post(id: item.id, data: item.data, name: item.name, title: item.title, date: item.date, tags: item.tags, indices: item.indices, serials: item.serials, links: item.links, years: item.years, persons: item.persons, movies: item.movies, books: item.books, type: item.postType(), textFormat: item.textFormat(), isFavourite: isFavourite)
            container.mainContext.insert(post)
        }
        
        try container.mainContext.save()
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

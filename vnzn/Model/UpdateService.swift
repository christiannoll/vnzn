import Foundation
import SwiftData

struct UpdateService {
    
    let contentParser = ContentParser()
    
    @MainActor
    func update(container: ModelContainer) async throws {
        let items = await fetchItems(fromUrl: VnznEnv.baseUrl + "xml/content.xml")
        for item in items {
            let post = Post(id: item.id, data: item.data, name: item.name, title: item.title, date: item.date, tags: item.tags, indices: item.indices, serials: item.serials, links: item.links, years: item.years, persons: item.persons, movies: item.movies, books: item.books, type: item.postType())
            container.mainContext.insert(post)
        }
        try container.mainContext.save()
    }
    
    private func fetchItems(fromUrl: String) async -> [Item] {
        do {
            let xmlString = try await Client().fetchData(fromUrl: fromUrl)
            let items = contentParser.parse(xmlString: xmlString)
            //items.sort { $0.date! > $1.date! }
            return items
        } catch {
            print(error)
            return []
        }
    }
}

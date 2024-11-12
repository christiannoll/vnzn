import Foundation

@Observable class PostViewModel {
    
    var posts = [Item]()
    let client = Client()
    let contentParser: ContentParser
    
    init() {
        contentParser = ContentParser()
    }
    
    func fetchPosts(fromUrl: String) async {
        do {
            let xmlString = try await client.fetchData(fromUrl: fromUrl)
            posts = contentParser.parse(xmlString: xmlString)
            posts.sort { $0.date! > $1.date! }
        } catch {
            print(error)
        }
    }
    
    func findPost(url: URL) -> Item? {
        var foundPost: Item?
        if let postUrl = URL(string: String(url.absoluteString.dropFirst())) {
            foundPost = posts.first(where: { $0.name == postUrl.pathComponents.last! })
        }
        return foundPost
    }
}

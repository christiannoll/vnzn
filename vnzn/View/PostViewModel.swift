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
}

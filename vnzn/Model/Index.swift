import Foundation

class Index {
    
    var indexItems: [IndexItem] = []
    private let lock = NSLock()

    var numberOfIndexItems: Int {
        get { return indexItems.count }
    }
    
    func createIndex(_ posts: [Post]) async {
        for post in posts {
            await addPost(post)
        }
        sort()
    }

    func getIndexItem(_ key: String) -> IndexItem? {
        indexItems.first { $0.key == key }
    }

    private func sort() {
        indexItems.sort { $0.key < $1.key }
    }
    
    private func addPost(_ post: Post) async {
        for indexItem in await getIndexItems(post) {
            indexItem.addPost(post)
        }
    }
    
    private func getIndexItems(_ post: Post) async -> [IndexItem] {
        var _indexItems: [IndexItem] = []
        lock.withLock {
            for index in post.indices {
                var found = false
                for indexItem in indexItems {
                    if index == indexItem.key {
                        _indexItems.append(indexItem)
                        found = true
                    }
                }
                if !found {
                    let indexItem = IndexItem(index)
                    _indexItems.append(indexItem)
                    indexItems.append(indexItem)
                }
            }
        }
        return _indexItems
    }
}

import Foundation

@Observable
class Index {
    
    var indexItems: [IndexItem] = []
    private let lock = NSLock()
    private var currentSortOrder = PopularSortOrder.alphabetical

    var numberOfIndexItems: Int {
        get { return indexItems.count }
    }

    @MainActor
    func createIndex(_ posts: [Post]) async {
        for post in posts {
            await addPost(post)
        }
        sort()
    }

    func getIndexItem(_ key: String) -> IndexItem? {
        indexItems.first { $0.key == key }
    }

    func sortByNextOrder() {
        lock.lock()
        currentSortOrder.next()
        sort()
        lock.unlock()
    }

    private func sort() {
        switch currentSortOrder {
        case .alphabetical: sortAlphabetical()
        case .mostPopular: sortMostPopular()
        case .leastPopular: sortLeastPopular()
        }
    }

    private func sortAlphabetical() {
        indexItems.sort { $0.key < $1.key }
    }

    private func sortMostPopular() {
        indexItems.sort { $0.posts.count > $1.posts.count }
    }

    private func sortLeastPopular() {
        indexItems.sort { $0.posts.count < $1.posts.count }
    }

    @MainActor
    private func addPost(_ post: Post) async {
        for indexItem in await getIndexItems(post) {
            indexItem.addPost(post)
        }
    }

    @MainActor
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

import Foundation

@Observable
class Tags {
    
    var tagItems: [TagItem] = []
    internal let lock = NSLock()
    private var currentSortOrder = SortOrder.alphabetical

    var numberOfTagItems: Int {
        tagItems.count
    }

    func sortByNextOrder() {
        lock.lock()
        currentSortOrder.next()
        sort()
        lock.unlock()
    }

    func sort() {
        switch currentSortOrder {
        case .alphabetical: sortAlphabetical()
        case .mostPopular: sortMostPopular()
        case .leastPopular: sortLeastPopular()
        }
    }

    private func sortAlphabetical() {
        tagItems.sort { $0.key < $1.key }
    }

    private func sortMostPopular() {
        tagItems.sort { $0.posts.count > $1.posts.count }
    }

    private func sortLeastPopular() {
        tagItems.sort { $0.posts.count < $1.posts.count }
    }

    @MainActor
    func addPost(_ post: Post) async {
        for tagItem in await getTagItems(post) {
            tagItem.addPost(post)
        }
    }

    @MainActor
    func createTags(_ posts: [Post]) async {
        for post in posts {
            await addPost(post)
        }
        sort()
    }
    
    func getTagItem(_ key: String) -> TagItem? {
        tagItems.first { $0.key == key }
    }

    @MainActor
    internal func getTagItems(_ post: Post) async -> [TagItem] {
        var _tagItems: [TagItem] = []
        lock.withLock() {
            for tag in post.tags {
                var found = false
                for tagItem in tagItems {
                    if tag == tagItem.key {
                        _tagItems.append(tagItem)
                        found = true
                    }
                }
                if !found {
                    let tagItem = TagItem(tag, "tags/")
                    _tagItems.append(tagItem)
                    tagItems.append(tagItem)
                }
            }
        }
        return _tagItems
    }
}

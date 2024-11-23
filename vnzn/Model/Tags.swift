import Foundation

@Observable
class Tags {
    
    var tagItems: [TagItem] = []
    
    /*var tagItems: [TagItem] {
        get { return _tagItems }
    }*/
    
    var numberOfTagItems: Int {
        tagItems.count
    }
    
    
    func sort() {
        tagItems.sort { $0.key < $1.key }
    }
    
    func addPost(_ post: Post) async {
        for tagItem in await getTagItems(post) {
            tagItem.addPost(post)
        }
    }
    
    func createTags(_ posts: [Post]) async {
        for post in posts {
            await addPost(post)
        }
        sort()
    }
    
    func getTagItem(_ key: String) -> TagItem? {
        tagItems.first { $0.key == key }
    }
    
    fileprivate func getTagItems(_ post: Post) async -> [TagItem] {
        var _tagItems: [TagItem] = []
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
        return _tagItems
    }
}

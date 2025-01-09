import Foundation

class Serials : Tags {

    func createSerials(_ posts: [Post]) async {
        for post in posts {
            await addPost(post)
        }

        sort()
    }

    internal override func getTagItems(_ post: Post) async -> [TagItem] {
        var _tagItems: [TagItem] = []
        lock.withLock() {
            for serial in post.serials {
                if serial.count > 0 {
                    var found = false
                    for tagItem in tagItems {
                        if serial == tagItem.key {
                            _tagItems.append(tagItem)
                            found = true
                        }
                    }
                    if !found {
                        let tagItem = TagItem(serial, "serials/")
                        _tagItems.append(tagItem)
                        tagItems.append(tagItem)
                    }
                }
            }
        }
        return _tagItems
    }
}

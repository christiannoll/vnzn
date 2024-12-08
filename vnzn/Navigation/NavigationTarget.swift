import Foundation

enum NavigationTarget: Hashable {
    case tag(TagItem)
    case serials
    case archive
    case archiveMonth([Post])
    case statistics
    case post(Post)
    case timeline
    case indexItem(IndexItem)
}

import Foundation

enum NavigationTarget: Hashable {
    case tag(TagItem)
    case serials
    case archive
    case archiveMonth(ArchiveMonth)
    case statistics
    case post(Post)
    case timeline
    case indexItem(IndexItem)
    case persons
    case movies
    case books
    case photos
    case shortStories
    case experiments
    case randomPost
    case personsCloud
    case person(RegisterItem)
    case topicsCloud
    case topic(RegisterItem)
    case tags
    case appInfo
    case widgetPost(Int)
    case past
    case privacy
    case termsOfUse
    case searchIntent(String)
    case searchHistory
    case quotes
    case imprint
    case copyright
    case similarPosts(Post)
}

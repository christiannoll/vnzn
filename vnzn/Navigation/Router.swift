import Foundation

@Observable class Router {
    
    enum Tabs: Hashable {
        case posts
        case index
        case tags
        case history
        case meta
    }
    
    var selectedTab = Tabs.posts
}

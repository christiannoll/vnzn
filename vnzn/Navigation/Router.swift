import Foundation

@Observable class Router {
    
    enum Tabs: Hashable {
        case timeline
        case favourites
        case index
        case tags
    }
    
    var selectedTab = Tabs.timeline
}

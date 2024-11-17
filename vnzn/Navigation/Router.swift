import Foundation

@Observable class Router {
    
    enum Tabs: Hashable {
        case timeline
        case favourites
        case index
    }
    
    var selectedTab = Tabs.timeline
}

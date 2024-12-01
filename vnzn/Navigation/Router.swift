import Foundation

@Observable class Router {
    
    enum Tabs: Hashable {
        case timeline
        case index
        case tags
        case history
        case meta
    }
    
    var selectedTab = Tabs.timeline
}

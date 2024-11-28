import Foundation

@Observable class Router {
    
    enum Tabs: Hashable {
        case timeline
        case index
        case tags
        case history
    }
    
    var selectedTab = Tabs.timeline
}

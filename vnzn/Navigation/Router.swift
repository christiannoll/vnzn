import Foundation
import SwiftUI

@Observable class Router {
    
    enum Tabs: Hashable {
        case posts
        case index
        case tags
        case history
        case meta
    }
    
    var selectedTab = Tabs.posts

    var postsViewNavigationPath = NavigationPath()
    var indexViewNavigationPath = NavigationPath()
    var tagsViewNavigationPath = NavigationPath()
    var historyViewNavigationPath = NavigationPath()
    var metaViewNavigationPath = NavigationPath()

    var currentNavigationPath: NavigationPath {
        get {
            switch selectedTab {
            case .posts:
                postsViewNavigationPath
            case .index:
                indexViewNavigationPath
            case .tags:
                tagsViewNavigationPath
            case .history:
                historyViewNavigationPath
            case .meta:
                metaViewNavigationPath
            }
        }
        set {
            switch selectedTab {
            case .posts:
                postsViewNavigationPath = newValue
            case .index:
                indexViewNavigationPath = newValue
            case .tags:
                tagsViewNavigationPath = newValue
            case .history:
                historyViewNavigationPath = newValue
            case .meta:
                metaViewNavigationPath = newValue
            }
        }
    }

    func resetNavigation() {
        currentNavigationPath = NavigationPath()
    }
}

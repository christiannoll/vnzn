import Foundation
import SwiftUI

@Observable class Router {
    
    enum Tabs: Hashable {
        case posts
        case discover
        case index
        case history
        case meta
    }
    
    var selectedTab = Tabs.posts

    var postsViewNavigationPath = NavigationPath()
    var indexViewNavigationPath = NavigationPath()
    var discoverViewNavigationPath = NavigationPath()
    var historyViewNavigationPath = NavigationPath()
    var metaViewNavigationPath = NavigationPath()

    var currentNavigationPath: NavigationPath {
        get {
            switch selectedTab {
            case .posts:
                postsViewNavigationPath
            case .index:
                indexViewNavigationPath
            case .discover:
                discoverViewNavigationPath
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
            case .discover:
                discoverViewNavigationPath = newValue
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

    func navigate(to url: URL) {
        var id = -1

        guard url.scheme == "vnznapp" else {
            return
        }

        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            print("Invalid URL")
            return
        }

        guard let action = components.host, action == "view-post" else {
            print("Unknown URL, we can't handle this one!")
            return
        }

        guard let postIdString = components.queryItems?.first(where: { $0.name == "id" })?.value else {
            print("Recipe name not found")
            return
        }

        id = Int(postIdString) ?? -1

        currentNavigationPath.append(NavigationTarget.widgetPost(id))
    }
}

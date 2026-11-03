import Foundation
import SwiftUI
import OSLog

@Observable class Router {
    
    enum Tabs: Hashable {
        case posts
        case discover
        case search
        case history
        case meta
    }
    
    var selectedTab = Tabs.posts

    var searchTerm: String? = nil

    private let logger = Logger(subsystem: "de.vnzn.vnzn", category: "Router")

    var postsViewNavigationPath = NavigationPath()
    var searchViewNavigationPath = NavigationPath()
    var discoverViewNavigationPath = NavigationPath()
    var historyViewNavigationPath = NavigationPath()
    var metaViewNavigationPath = NavigationPath()

    var currentNavigationPath: NavigationPath {
        get {
            switch selectedTab {
            case .posts:
                postsViewNavigationPath
            case .search:
                searchViewNavigationPath
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
            case .search:
                searchViewNavigationPath = newValue
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

    @MainActor
    func navigate(to url: URL) {
        guard url.scheme == "vnznapp" else {
            logger.debug("Invalid URL scheme")
            return
        }

        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            logger.debug("Invalid URL")
            return
        }

        let action = components.host
        switch action {
        case "view-post":
            handleViewPostLink(components)
        case "search-post":
            handleSearchPostLink(components)
        default:
            logger.debug("Unknown URL, we can't handle this one!")
        }
    }

    private func handleViewPostLink(_ components: URLComponents) {
        guard let postIdString = components.queryItems?.first(where: { $0.name == "id" })?.value else {
            logger.debug("Id not found")
            return
        }

        let id = Int(postIdString) ?? -1
        currentNavigationPath.append(NavigationTarget.widgetPost(id))
    }

    @MainActor
    private func handleSearchPostLink(_ components: URLComponents) {
        guard let queryString = components.queryItems?.first(where: { $0.name == "q" })?.value else {
            logger.debug("Query not found")
            return
        }
        
        currentNavigationPath.append(NavigationTarget.searchIntent(queryString))
    }
}

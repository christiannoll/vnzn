import SwiftUI

struct NavigationDestination: ViewModifier {

    func body(content: Content) -> some View {
        content
            .navigationDestination(for: NavigationTarget.self) { navTarget in
                switch navTarget {
                case .tag(let tagItem):
                    TagItemView(posts: tagItem.posts)
                case .serials:
                    SerialsView()
                case .archive:
                    ArchiveView()
                case .archiveMonth(let posts):
                    ArchiveMonthView(posts: posts)
                case .statistics:
                    StatisticsView()
                case .timeline:
                    TimelineView()
                case .post(let post):
                    PostView(post: post)
                case .indexItem(let indexItem):
                    IndexItemView(posts: indexItem.posts)
                case .persons:
                    PersonsView()
                case .movies:
                    MoviesView()
                }
            }
    }
}

extension View {
    func selectNavigationDestination() -> some View {
        modifier(NavigationDestination())
    }
}

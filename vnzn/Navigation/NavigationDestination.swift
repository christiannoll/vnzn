import SwiftUI

struct NavigationDestination: ViewModifier {

    func body(content: Content) -> some View {
        content
            .navigationDestination(for: NavigationTarget.self) { navTarget in
                switch navTarget {
                case .tag(let tagItem):
                    TagItemView(tagItem: tagItem)
                case .serials:
                    SerialsView()
                case .archive:
                    ArchiveView()
                case .archiveMonth(let archiveMonth):
                    ArchiveMonthView(archiveMonth: archiveMonth)
                case .statistics:
                    StatisticsView()
                case .timeline:
                    TimelineView()
                case .post(let post):
                    PostView(post: post)
                case .indexItem(let indexItem):
                    IndexItemView(indexItem: indexItem)
                case .persons:
                    PersonsView()
                case .movies:
                    MoviesView()
                case .books:
                    BooksView()
                case .photos:
                    PhotosView()
                case .shortStories:
                    ShortStoriesView()
                case .experiments:
                    ExperimentsView()
                case .randomPost:
                    RandomPostView()
                case .personsCloud:
                    PersonsCloudView()
                case .person(let registerItem):
                    RegisterItemView(item: registerItem)
                case .topicsCloud:
                    TopicsCloudView()
                case .topic(let registerItem):
                    RegisterItemView(item: registerItem)
                case .tags:
                    TagsView()
                case .appInfo:
                    AppInfoView()
                case .widgetPost(let url):
                    PostWidgetView(url: url)
                case .past:
                    PastView()
                case .privacy:
                    PrivacyView()
                }
            }
    }
}

extension View {
    func selectNavigationDestination() -> some View {
        modifier(NavigationDestination())
    }
}

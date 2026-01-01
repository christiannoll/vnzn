import SwiftUI

struct MetaItem {
    let navigationTarget: NavigationTarget
    let title: String
    let localizedValue: String

    init(navigationTarget: NavigationTarget, title: String) {
        self.navigationTarget = navigationTarget
        self.title = title
        self.localizedValue = String(localized: String.LocalizationValue(title))
    }
}

@Observable
class MetaViewModel {

    var metaItems = [MetaItem]()

    private var currentSortOrder = MetaSortOrder.original

    init() {
        metaItems = setupItems()
    }

    private func setupItems() -> [MetaItem] {
        var metaItems: [MetaItem] = []
        metaItems.append(MetaItem(navigationTarget: .tags, title: "Kategorien"))
        metaItems.append(MetaItem(navigationTarget: .index, title: "Index"))
        metaItems.append(MetaItem(navigationTarget: .serials, title: "Serien"))
        metaItems.append(MetaItem(navigationTarget: .archive, title: "Archiv"))
        metaItems.append(MetaItem(navigationTarget: .statistics, title: "Statistik"))
        metaItems.append(MetaItem(navigationTarget: .timeline, title: "Timeline"))
        metaItems.append(MetaItem(navigationTarget: .persons, title: "Personen"))
        metaItems.append(MetaItem(navigationTarget: .movies, title: "Filme"))
        metaItems.append(MetaItem(navigationTarget: .books, title: "Bücher"))
        metaItems.append(MetaItem(navigationTarget: .photos, title: "Fotos"))
        metaItems.append(MetaItem(navigationTarget: .personsCloud, title: "Personenwolke"))
        metaItems.append(MetaItem(navigationTarget: .topicsCloud, title: "Themenwolke"))
        metaItems.append(MetaItem(navigationTarget: .shortStories, title: "Kurzgeschichten"))
        metaItems.append(MetaItem(navigationTarget: .ai, title: "Artificial Intelligence"))
        metaItems.append(MetaItem(navigationTarget: .experiments, title: "Experimente"))
        metaItems.append(MetaItem(navigationTarget: .randomPost, title: "Zufall"))
        return metaItems
    }

    func sortByNextOrder() {
        currentSortOrder.next()
        sort()
    }

    private func sort() {
        switch currentSortOrder {
        case .original: metaItems = sortOriginal()
        case .ascending: metaItems = sortAscending()
        case .descending: metaItems = sortDescending()
        }
    }

    private func sortAscending() -> [MetaItem] {
        metaItems.sorted { $0.localizedValue.localizedStandardCompare($1.localizedValue) == .orderedAscending }
    }

    private func sortDescending()  -> [MetaItem] {
        metaItems.sorted { $0.localizedValue.localizedStandardCompare($1.localizedValue) == .orderedDescending }
    }

    private func sortOriginal()  -> [MetaItem] {
        metaItems.removeAll()
        return setupItems()
    }
}

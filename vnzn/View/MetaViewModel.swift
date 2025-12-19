import SwiftUI

struct MetaItem {
    let navigationTarget: NavigationTarget
    let title: String
}

@Observable
class MetaViewModel {

    var metaItems = [MetaItem]()

    private var currentSortOrder = MetaSortOrder.original

    init() {
        setupItems()
    }

    private func setupItems() {
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
    }

    func sortByNextOrder() {
        currentSortOrder.next()
        sort()
    }

    private func sort() {
        switch currentSortOrder {
        case .original: sortOriginal()
        case .ascending: sortAscending()
        case .descending: sortDescending()
        }
    }

    private func sortAscending() {
        metaItems.sort { $0.title < $1.title }
    }

    private func sortDescending() {
        metaItems.sort { $0.title > $1.title }
    }

    private func sortOriginal() {
        metaItems.removeAll()
        setupItems()
    }
}

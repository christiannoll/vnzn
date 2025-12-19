enum PopularSortOrder {
    case alphabetical
    case mostPopular
    case leastPopular

    mutating func next() {
        switch self {
        case .alphabetical: self = .mostPopular
        case .mostPopular: self = .leastPopular
        case .leastPopular: self = .alphabetical
        }
    }
}

enum MetaSortOrder {
    case original
    case ascending
    case descending

    mutating func next() {
        switch self {
        case .original: self = .ascending
        case .ascending: self = .descending
        case .descending: self = .original
        }
    }
}

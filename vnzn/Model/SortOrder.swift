enum SortOrder {
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

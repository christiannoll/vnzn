import Foundation

class TimelineItem: PostListItem, Identifiable, Hashable {
    
    private let _year: Int
 
    init(_ year: Int) {
        self._year = year
    }
    
    var year: Int {
        get { return _year }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(_year)
    }
}

extension TimelineItem: Equatable {}

func ==(lhs: TimelineItem, rhs: TimelineItem) -> Bool {
    lhs.year == rhs.year
}

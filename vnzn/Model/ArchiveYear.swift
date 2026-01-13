import Foundation

class ArchiveYear: Hashable {
    
    private var _year: Int
    private var _months: [ArchiveMonth] = []
    
    var year: Int {
        get { return _year }
    }
    
    var name: String {
        get { return String(_year) }
    }
    
    var months: [ArchiveMonth] {
        get { return _months }
    }
    
    init(_ year: Int) {
        _year = year
    }
    
    public func addPost(_ post: Post) {
        if let month = getMonth(post) {
            month.addPost(post)
        }
    }
    
    private func getMonth(_ post: Post) -> ArchiveMonth? {
        for month in _months {
            if let postDate = post.date {
                let comps = Calendar.current.dateComponents([.month], from: postDate)
                if comps.month! == month.month {
                    return month
                }
            }
        }
        return createMonth(post)
    }
    
    private func createMonth(_ post: Post) -> ArchiveMonth? {
        guard let postDate = post.date else { return nil }
        let comps = Calendar.current.dateComponents([.month], from: postDate)
        guard let compsMonth = comps.month else { return nil }
        let month = ArchiveMonth(compsMonth, _year)
        _months.append(month)
        return month
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(_year)
    }
}

extension ArchiveYear: Equatable {}

func ==(lhs: ArchiveYear, rhs: ArchiveYear) -> Bool {
    lhs.year == rhs.year
}

import Foundation

class ArchiveYear {
    
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
        let month = getMonth(post)
        month.addPost(post)
    }
    
    private func getMonth(_ post: Post) -> ArchiveMonth {
        for month in _months {
            let comps = Calendar.current.dateComponents([.month], from: post.date!)
            if comps.month! == month.month {
                return month
            }
        }
        return createMonth(post)
    }
    
    private func createMonth(_ post: Post) -> ArchiveMonth {
        let comps = Calendar.current.dateComponents([.month], from: post.date!)
        let month = ArchiveMonth(comps.month!, _year)
        _months.append(month)
        return month
    }
}

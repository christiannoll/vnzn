import Foundation

class ArchiveMonth: Hashable {

    private var _month: Int
    private var _year: Int
    var posts: [Post] = []

    var month: Int {
        get { return _month }
    }
    
    var monthName: String {
        get { return getMonthName() }
    }
    
    var yearName: String {
        get { return String(_year) }
    }
    
    init(_ month: Int, _ year: Int) {
        _month = month
        _year = year
    }
    
    public func addPost(_ post: Post) {
        posts.append(post)
    }

    private func createLinkUrl() -> String {
        let post = posts[0]
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "de_DE")
        dateFormatter.dateFormat = "yyyy/MM/"
        guard let postDate = post.date else { return "" }
        return VnznEnv.baseUrl + dateFormatter.string(from: postDate)
    }
    
    private func getMonthName() -> String {
        let post = posts[0]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        guard let postDate = post.date else { return "" }
        return dateFormatter.string(from: postDate)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(_year)
        hasher.combine(_month)
    }
}

extension ArchiveMonth: Equatable {}

func ==(lhs: ArchiveMonth, rhs: ArchiveMonth) -> Bool {
    lhs.month == rhs.month && lhs.yearName == rhs.yearName
}


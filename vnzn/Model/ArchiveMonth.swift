import Foundation

class ArchiveMonth {
    
    private var _month: Int
    private var _year: Int
    private var posts: [Post] = []

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
        return VnznEnv.baseUrl + dateFormatter.string(from: post.date!)
    }
    
    private func getMonthName() -> String {
        let post = posts[0]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: post.date!)
    }
}

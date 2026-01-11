import Foundation

extension Date {
    
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self) ?? self
    }

    static func parseDate(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.locale = Locale.init(identifier: "de_DE")

        let date = dateFormatter.date(from: dateString)
        return date
    }

    static func createPostDate(_ post: Post) -> String {
        createPostDate(post.date)
    }

    static func createPostDate(_ date: Date?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "de_DE")
        dateFormatter.dateFormat = "dd MMM yyyy"
        if let date {
            return dateFormatter.string(from: date)
        } else {
            return ""
        }
    }
}

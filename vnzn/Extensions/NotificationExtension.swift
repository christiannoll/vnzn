import Foundation

extension NotificationCenter {

    public enum `Type`: String {
        case fetchPosts
    }

    @MainActor
    public static func post(_ type: `Type`, object anObject: Any? = nil) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Notification.Name(type.rawValue), object: anObject)
        }
    }

    public static func publisher(for type: `Type`, object: AnyObject? = nil) -> NotificationCenter.Publisher {
        NotificationCenter.default.publisher(for: NSNotification.Name(type.rawValue), object: object)
    }

}

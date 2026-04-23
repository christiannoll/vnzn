import Foundation
import SwiftUI
import UserNotifications
import OSLog

enum NewBlogEntryInfo {
    static let key = "type"
    static let value = "new_blog_entry"
}

final class UserNotificationController: Sendable {

    let logger = Logger()
    @MainActor public static let shared: UserNotificationController = .init()

    public func sendNotification(message: String, title: String, sound: Bool) async {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()

        switch settings.authorizationStatus {
        case .authorized:
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = NSLocalizedString(message, comment: "")
            content.userInfo = [NewBlogEntryInfo.key: NewBlogEntryInfo.value]
            content.sound = sound ? .default : nil
            content.interruptionLevel = .active
            let uuidString = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: nil)
            let notificationCenter = UNUserNotificationCenter.current()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                notificationCenter.add(request)
            }
        case .denied:
            logger.debug("Denied authorization status")
        default:
            logger.debug("Unhandled authorization status")
        }
    }

    public func areNotificationsAuthorized() async -> Bool {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()

        return settings.authorizationStatus == .authorized
    }
}

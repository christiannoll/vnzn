import Foundation
import SwiftUI
import UserNotifications
import OSLog

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
            content.sound = sound ? .default : nil
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

import UserNotifications

@Observable
class NotificationHandler: NSObject, UNUserNotificationCenterDelegate {

    var newItemsAvailable = false

    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }

    // User tippt auf Notification
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                 didReceive response: UNNotificationResponse,
                                 withCompletionHandler completionHandler: @escaping () -> Void) {
        handleUserInfo(response.notification.request.content.userInfo)
        completionHandler()
    }

    // Notification im Vordergrund
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                 willPresent notification: UNNotification,
                                 withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }

    private func handleUserInfo(_ userInfo: [AnyHashable: Any]) {
        guard let type = userInfo[NewBlogEntryInfo.key] as? String, type == NewBlogEntryInfo.value else { return }
        DispatchQueue.main.async {
            self.newItemsAvailable = true
        }
    }
}


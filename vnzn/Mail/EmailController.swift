import UIKit
import OSLog

public struct EmailController {

    private static let logger = Logger()

    @MainActor
    public static func sendEmail(address: String, subject: String = "", message: String = "") {
        var components = URLComponents()
        components.scheme = "mailto"
        components.path = address
        components.queryItems = [
              URLQueryItem(name: "subject", value: subject),
              URLQueryItem(name: "body", value: message)
        ]

        guard let url = components.url else {
            logger.debug("Failed to create mailto URL")
            return
        }

        UIApplication.shared.open(url) { success in
            if !success {
                logger.debug("Failed to open mailto URL \(url)")
            }
        }
    }
}

import UIKit

public struct EmailController {

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
            print("Failed to create mailto URL")
            return
        }

        UIApplication.shared.open(url) { success in
            if !success {
                print("Failed to open mailto URL \(url)")
            }
        }
    }
}

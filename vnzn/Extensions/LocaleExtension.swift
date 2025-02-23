import Foundation

extension Locale {

    public static let dataKey = "language"

    public static var currentLanguage: String? {
        Locale.preferredLanguages.first
    }
}

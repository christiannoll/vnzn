import Foundation

struct VnznEnv {

    static var isCurrentLanguageEnglish: Bool {
        if let lang = Locale.currentLanguage, lang.contains("en") {
            return true
        }
        return false
    }

    static var baseUrl: String {
        if isCurrentLanguageEnglish {
            return "http://localhost:8000/en/"
            //return "https://www.vnzn.de/en/"
        }
        return "http://localhost:8000/"
        //return "https://www.vnzn.de/"
    }

    public static let baseRootUrl = "http://localhost:8000/"
    //public static let baseRootUrl = "https://www.vnzn.de/"
}

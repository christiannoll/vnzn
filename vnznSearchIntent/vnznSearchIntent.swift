import AppIntents

struct vnznSearchIntent: AppIntent {
    static var title: LocalizedStringResource { "vnznSearchIntent" }
    
    func perform() async throws -> some IntentResult {
        return .result()
    }
}

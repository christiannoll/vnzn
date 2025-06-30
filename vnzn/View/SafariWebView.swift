import SwiftUI
import WebKit

struct SafariWebView: View {

    let url: URL

    var body: some View {
        WebView(url: url)
            .toolbar(.hidden, for: .tabBar)
    }
}

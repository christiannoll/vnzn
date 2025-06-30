import SwiftUI
import WebKit

struct SafariWebView: View {

    let url: URL

    @State private var page = WebPage()
    @State private var findNavigatorIsPresented = false

    var body: some View {
        WebView(page)
            .toolbar(.hidden, for: .tabBar)
            .navigationTitle(page.title)
            .onAppear {
                page.load(URLRequest(url: url))
            }
            .ignoresSafeArea(.all, edges: .bottom)
            .findNavigator(isPresented: $findNavigatorIsPresented)
            .toolbar {
                ToolbarItemGroup {
                    Button("Find", systemImage: "magnifyingglass") {
                        findNavigatorIsPresented.toggle()
                    }
                }
            }
    }
}

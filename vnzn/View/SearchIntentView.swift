import SwiftUI

struct SearchIntentView: View {

    let searchTerm: String

    var body: some View {
        PostsView(searchText: searchTerm)
            .onAppear {
                SwiftDataService.shared.saveSearchItem(searchTerm: searchTerm)
            }
    }
}

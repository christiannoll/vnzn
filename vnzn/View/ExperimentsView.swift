import SwiftUI

struct ExperimentsView: View {

    @Environment(Router.self) var router: Router

    var body: some View {
        List {
            Button {
                router.currentNavigationPath.append(NavigationTarget.past)
            } label: {
                HStack {
                    Text("Reise in die Vergangenheit")
                    Spacer()
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .navigationTitle("Experimente")
        .navigationBarTitleDisplayMode(.inline)
    }
}

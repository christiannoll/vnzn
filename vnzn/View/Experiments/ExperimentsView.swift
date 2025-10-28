import SwiftUI

struct ExperimentsView: View {

    @Environment(Router.self) var router: Router

    var body: some View {
        List {
            ExperimentButton(navigationTarget: NavigationTarget.past, title: "Reise in die Vergangenheit")
            ExperimentButton(navigationTarget: NavigationTarget.searchHistory, title: "Suchverlauf")
            ExperimentButton(navigationTarget: NavigationTarget.quotes, title: "Zitate")
        }
        .navigationTitle("Experimente")
        .buttonStyle(.plain)
    }
}

struct ExperimentButton: View {

    @Environment(Router.self) var router: Router
    let navigationTarget: NavigationTarget
    let title: LocalizedStringKey

    var body: some View {
        Button {
            router.currentNavigationPath.append(navigationTarget)
        } label: {
            HStack {
                Text(title)
                Spacer()
            }
            .contentShape(Rectangle())
        }
    }
}

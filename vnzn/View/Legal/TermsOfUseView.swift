import SwiftUI

struct TermsOfUseView: View {
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Die Nutzung von VnznApp unterliegt Apples Standard-EULA für Apps. In VnznApp bereitgestellte Trinkgelder schalten keine zusätzlichen Inhalte in der App frei.")
                .padding()
            Spacer()
        }
        .navigationTitle("Nutzungsbedingungen")
    }
}

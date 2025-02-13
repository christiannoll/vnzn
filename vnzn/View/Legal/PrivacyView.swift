import SwiftUI

struct PrivacyView: View {

    var body: some View {
        VStack {
            Text("VnznApp sammelt oder verarbeitet keine persönlichen Daten seiner Benutzer. Die App wird verwendet, um eine Verbindung zu Vnzn-Servern herzustellen, die möglicherweise persönliche Daten sammeln und nicht von dieser Datenschutzrichtlinie abgedeckt sind.")
                .padding()
            Spacer()
        }
            .navigationTitle("Datenschutzerklärung")
    }
}

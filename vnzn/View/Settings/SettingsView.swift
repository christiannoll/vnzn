import SwiftUI

struct SettingsView: View {

    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Entdecken") {

                }
            }
            .navigationTitle("Einstellungen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    VStack {
                        Button {
                            dismiss()
                        } label: {
                            Text("Fertig")
                                .foregroundStyle(Color.accentColor)
                        }
                        Spacer()
                    }
                    .padding(.trailing, 16)
                }
            }
        }
    }
}

import SwiftUI

struct AppInfoView: View {
    var body: some View {
        List {
            Button {
            } label: {
                HStack {
                    Image(systemName: "lock")
                        .foregroundStyle(Color.accentColor)
                    Text("Datenschutzerklärung")
                    Spacer()
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            Button {
            } label: {
                HStack {
                    Image(systemName: "checkmark.shield")
                        .foregroundStyle(Color.accentColor)
                    Text("Nutzungsbedingungen")
                    Spacer()
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .navigationTitle("vnzn")
        .navigationBarTitleDisplayMode(.inline)
    }
}


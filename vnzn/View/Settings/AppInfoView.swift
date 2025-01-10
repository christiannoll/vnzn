import SwiftUI

struct AppInfoView: View {
    var body: some View {
        
        List {
            Section("Version: \(AppVersionProvider.appVersion())") {
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
                Button {
                    sendEmail()
                } label: {
                    HStack {
                        Image(systemName: "ant.circle")
                            .foregroundStyle(Color.accentColor)
                        Text("Einen Fehler melden")
                        Spacer()
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .navigationTitle("App")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func sendEmail() {
        EmailController.sendEmail(address: "webmaster@vnzn.de",
                                  subject: "BUG | v.n.z.n | iOS",
                                  message: "")
    }
}

enum AppVersionProvider {
    static func appVersion(in bundle: Bundle = .main) -> String {
        guard let version = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
            fatalError("CFBundleShortVersionString should not be missing from info dictionary")
        }
        return version
    }
}


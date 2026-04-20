import SwiftUI

struct AppInfoView: View {

    @Environment(Router.self) var router: Router

    var body: some View {
        List {
            Section("Version \(Bundle.main.appVersion) (\(Bundle.main.buildNumber))") {
                Button {
                } label: {
                    HStack {
                        Image(systemName: "house")
                        Text("Posts: www.vnzn.blog")
                        Spacer()
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                AppInfoButton(action: {
                    router.currentNavigationPath.append(NavigationTarget.imprint)
                }, imageName: "scroll", title: "Impressum")
                AppInfoButton(action: {
                    router.currentNavigationPath.append(NavigationTarget.copyright)
                }, imageName: "c.circle", title: "Copyright")
                AppInfoButton(action: {
                    router.currentNavigationPath.append(NavigationTarget.privacy)
                }, imageName: "lock", title: "Datenschutzerklärung")
                AppInfoButton(action: {
                    router.currentNavigationPath.append(NavigationTarget.termsOfUse)
                }, imageName: "checkmark.shield", title: "Nutzungsbedingungen")
                AppInfoButton(action: {
                    sendEmail()
                }, imageName: "ant.circle", title: "Einen Fehler melden")
            }
        }
        .navigationTitle("App")
    }

    private func sendEmail() {
        EmailController.sendEmail(address: "webmaster@vnzn.de",
                                  subject: "BUG | v.n.z.n | iOS",
                                  message: "")
    }
}

struct AppInfoButton: View {

    let action: () -> Void
    let imageName: String
    let title: LocalizedStringKey

    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Image(systemName: imageName)
                Text(title)
                Spacer()
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

extension Bundle {
    var appVersion: String {
        infoDictionary?["CFBundleShortVersionString"] as? String ?? "?"
    }

    var buildNumber: String {
        infoDictionary?["CFBundleVersion"] as? String ?? "?"
    }
}


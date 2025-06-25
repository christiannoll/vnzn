import SwiftUI

struct AppInfoView: View {

    @Environment(Router.self) var router: Router

    var body: some View {
        List {
            Section("Version: \(AppVersionProvider.appVersion())") {
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
        .navigationBarTitleDisplayMode(.inline)
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
    let title: String

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

enum AppVersionProvider {
    static func appVersion(in bundle: Bundle = .main) -> String {
        guard let version = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
            fatalError("CFBundleShortVersionString should not be missing from info dictionary")
        }
        return version
    }
}


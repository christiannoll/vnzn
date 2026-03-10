import SwiftUI

struct CopyrightView: View {
    
    var body: some View {
        Form {
            Section("Copyright") {
                Text("© Copyright 2019-2026 – Urheberrechtshinweis").bold()
                Text("Alle Inhalte dieses Internetangebotes, insbesondere Texte, Fotografien, Bilder und Grafiken sind urheberrechtlich geschützt. Das Urheberrecht liegt, soweit nicht ausdrücklich anders gekennzeichnet, bei Christian Noll. Bitte fragen Sie mich, falls Sie die Inhalte dieses Internetangebotes verwenden möchten.")
            }
        }
    }
}


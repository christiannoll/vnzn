import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            HStack() {
                Spacer()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
                Spacer()
            }
            Text("Lade Daten")
                .padding()
        }
    }
}

#Preview {
    LoadingView()
}

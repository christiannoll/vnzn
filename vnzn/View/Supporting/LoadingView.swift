import SwiftUI

struct LoadingView: View {
    var body: some View {
        HStack() {
            Spacer()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(1.5)
            Spacer()
        }
    }
}

#Preview {
    LoadingView()
}

import SwiftUI

struct IndexView: View {
    
    @Environment(Index.self) var index: Index
    
    var body: some View {
        Text("Index")
    }
}

#Preview {
    IndexView()
}

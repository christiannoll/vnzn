import SwiftUI

struct IndexItemView: View {
    
    let indexItem: IndexItem
    
    var body: some View {
        Text(indexItem.linkTitle)
    }
}

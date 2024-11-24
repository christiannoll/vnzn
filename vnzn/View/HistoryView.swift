import SwiftUI
import SwiftData

struct HistoryView: View {
    
    @State private var path = NavigationPath()
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \HistoryItem.date, order: .reverse) var items: [HistoryItem]
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(items) { item in
                    Button {
                        path.append(item.post!)
                    } label: {
                        HStack {
                            Text(item.post?.title ?? "")
                            Text(item.date?.description ?? "")
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .navigationDestination(for: Post.self) { post in
                PostView(post: post, path: $path)
            }
            .navigationTitle("Verlauf")
            .scrollContentBackground(.hidden)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Löschen") {
                        deleteHistory()
                    }
                }
            }
        }
    }
    
    private func deleteHistory() {
        do {
            try modelContext.delete(model: HistoryItem.self)
        } catch {
            print("Failed to delete all schools.")
        }
    }
}


import SwiftUI

struct ArchiveMonthView: View {

    let archiveMonth: ArchiveMonth

    var body: some View {
        List {
            ForEach (archiveMonth.posts) { post in
                PostRow(post: post)
            }
        }
        .scrollContentBackground(.hidden)
        .navigationTitle(archiveMonth.monthName)
    }
}

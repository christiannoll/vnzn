import SwiftUI

struct ArchiveMonthView: View {

    let archiveMonth: ArchiveMonth

    var body: some View {
        List {
            ForEach (archiveMonth.posts) { post in
                PostRow(post: post, posts: archiveMonth.posts, action: {})
            }
        }
        .scrollContentBackground(.hidden)
        .navigationTitle(archiveMonth.monthName)
    }
}

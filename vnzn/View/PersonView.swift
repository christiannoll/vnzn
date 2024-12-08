import SwiftUI

struct PersonView: View {

    let person: RegisterItem
    @State private var selectedPost: Post? = nil

    var body: some View {
        List {
            ForEach (person.posts) { post in
                PostRow(post: post, selectedPost: $selectedPost)
            }
        }
        .navigationTitle(person.content)
    }
}

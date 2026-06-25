import SwiftUI

struct TagsGridView: View {

    let tagItems: [TagItem]

    @Environment(Router.self) var router: Router

    @State private var favoritedIDs: Set<TagItem.ID> = []

    var sortedItems: [TagItem] {
        tagItems.sorted {
            let aFav = favoritedIDs.contains($0.id)
            let bFav = favoritedIDs.contains($1.id)
            if aFav != bFav { return aFav }
            return $0.tagTitle < $1.tagTitle
        }
    }

    var body: some View {
        @Bindable var router = router
        LazyVGrid(
            columns: [
                GridItem(.flexible(minimum: 50, maximum: .infinity)),
                GridItem(.flexible(minimum: 50, maximum: .infinity))
            ],
            alignment: .leading,
            spacing: 10
        ) {
            ForEach (sortedItems) { tagItem in
                Button {
                    router.currentNavigationPath.append(NavigationTarget.tag(tagItem))
                } label: {
                    VStack(alignment: .leading) {
                        HStack {
                            Spacer()
                            StarButton(tagItem: tagItem, favoritedIDs: $favoritedIDs)
                        }
                        Text(tagItem.tagTitle)
                            .bold()
                            .padding(.horizontal)
                            .padding(.top, 4)
                            .foregroundStyle(.white)
                    }
                    .frame(height: 70)
                    .frame(maxWidth: .infinity)
                }
                .background(
                    Color.purple.gradient.opacity(0.8),
                    in: RoundedRectangle(
                        cornerRadius: 16,
                        style: .continuous
                    )
                )
            }
        }
    }
}

struct StarButton: View {

    let tagItem: TagItem
    @Binding var favoritedIDs: Set<TagItem.ID>
    @State private var isStarred = false

    var body: some View {
        let isStarred = favoritedIDs.contains(tagItem.id)
        Button {
            withAnimation(.spring(duration: 0.4)) {
                if isStarred {
                    favoritedIDs.remove(tagItem.id)
                } else {
                    favoritedIDs.insert(tagItem.id)
                }
            }
        } label: {
            Image(systemName: isStarred ? "star.fill" : "star")
                .padding(.horizontal)
                .foregroundStyle(.white)
        }
        .buttonStyle(.plain)
    }
}

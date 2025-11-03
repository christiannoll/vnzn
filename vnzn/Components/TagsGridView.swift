import SwiftUI

struct TagsGridView: View {

    let tagItems: [TagItem]

    @Environment(Router.self) var router: Router

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
            ForEach (tagItems) { tagItem in
                Button {
                    router.currentNavigationPath.append(NavigationTarget.tag(tagItem))
                } label: {
                    VStack(alignment: .leading) {
                        HStack {
                            Spacer()
                            Image(systemName: "star")
                                .padding(.horizontal)
                                .foregroundStyle(.background)
                        }
                        Text(tagItem.tagTitle)
                            .bold()
                            .padding(.horizontal)
                            .padding(.top, 4)
                            .foregroundColor(.white)
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

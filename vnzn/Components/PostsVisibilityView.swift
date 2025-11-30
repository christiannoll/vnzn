import SwiftUI
import SwiftData

struct PostsVisibilityView: ToolbarContent {

    @Query() var postsVisibilities: [PostsVisibility]
    var postsVisibility: PostsVisibility? {
        postsVisibilities.first
    }

    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Menu("menu", systemImage: "line.3.horizontal.decrease") {
                Button() {
                    if let postsVisibility {
                        postsVisibility.onlyFavourites.toggle()
                        SwiftDataService.shared.save()
                    }
                } label: {
                    if let postsVisibility {
                        Label("Favoriten", systemImage: postsVisibility.onlyFavourites ? "star.fill" : "star")
                    }
                }
                Button() {
                    if let postsVisibility {
                        postsVisibility.oldestFirst.toggle()
                        SwiftDataService.shared.save()
                    }
                } label: {
                    if let postsVisibility {
                        Label("Älteste zuerst", systemImage: postsVisibility.oldestFirst ? "arrow.up.arrow.down.circle.fill" : "arrow.up.arrow.down.circle")
                    }
                }
                Divider()
                Button() {
                    if let postsVisibility {
                        postsVisibility.postsLimit = .ten
                        SwiftDataService.shared.save()
                    }
                } label: {
                    if let postsVisibility {
                        Label("10 Posts", systemImage: postsVisibility.postsLimit == .ten ? "checkmark.square" : "square")
                    }
                }
                Button() {
                    if let postsVisibility {
                        postsVisibility.postsLimit = .twenty
                        SwiftDataService.shared.save()
                    }
                } label: {
                    if let postsVisibility {
                        Label("20 Posts", systemImage: postsVisibility.postsLimit == .twenty ? "checkmark.square" : "square")
                    }
                }
                Button() {
                    if let postsVisibility {
                        postsVisibility.postsLimit = .fifty
                        SwiftDataService.shared.save()
                    }
                } label: {
                    if let postsVisibility {
                        Label("50 Posts", systemImage: postsVisibility.postsLimit == .fifty ? "checkmark.square" : "square")
                    }
                }
                Button() {
                    if let postsVisibility {
                        postsVisibility.postsLimit = .all
                        SwiftDataService.shared.save()
                    }
                } label: {
                    if let postsVisibility {
                        Label("Alle", systemImage: postsVisibility.postsLimit == .all ? "checkmark.square" : "square")
                    }
                }
            }
        }
    }
}

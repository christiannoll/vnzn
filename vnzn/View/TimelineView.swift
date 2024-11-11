import SwiftUI

struct TimelineView: View {
    
    private var model = PostViewModel()
    @State private var searchText = ""
    @State private var path = NavigationPath()
    @State private var selectedPost: Item? = nil
    
    init() {
        
    }
    
    var searchResults: [Item] {
        if searchText.isEmpty {
            return model.posts
        } else {
            return model.posts.filter { $0.data.contains(searchText) }
        }
    }

    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach (searchResults) { post in
                    if post.itemType() == .text {
                        Button {
                            selectedPost = post
                            path.append(post)
                        } label: {
                            VStack(alignment: .leading) {
                                Text(post.title)
                                    .padding(.top, 20)
                                Text(createPostDate(post)).foregroundStyle(.secondary)
                            }
                        }
                        .buttonStyle(.plain)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .listRowBackground(Color.clear)
                    } else {
                        VStack(alignment: .center) {
                            HStack {
                                Spacer()
                                Button {
                                    selectedPost = post
                                    path.append(post)
                                } label: {
                                    PostImage(post: post)
                                        .frame(width: 200, height: 200)
                                        .padding(.top, 30)
                                }
                                Spacer()
                            }
                            Text(createPostDate(post)).foregroundStyle(.secondary)
                            
                        }
                        .listRowBackground(Color.clear)
                    }
                }
            }
            .navigationDestination(for: Item.self) { post in
                PostView(post: post, model: model)
            }
            .searchable(text: $searchText, prompt: "vnzn durchsuchen")
            .scrollContentBackground(.hidden)
            .navigationTitle("v.n.z.n")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarTitleTextColor(.blue)
            /*.toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Image(systemName: "folder")
                }
                
                ToolbarItem(placement: .bottomBar) {
                    Image(systemName: "message")
                }
            }*/
            .scrollContentBackground(.hidden)
        }
    }
    
    private func createPostDate(_ item: Item) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "de_DE")
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: item.date!)
    }
}

extension View {
    @available(iOS 14, *)
    func navigationBarTitleTextColor(_ color: Color) -> some View {
        let uiColor = UIColor(color)
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor ]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor ]
        return self
    }
}

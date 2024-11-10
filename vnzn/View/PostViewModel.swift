//
//  PostViewModel.swift
//  TestMarkdown
//
//  Created by Christian on 09.11.24.
//

import Foundation

@Observable class PostViewModel {
    
    var posts: [Item]
    
    init() {
        let contentParser = ContentParser()
        posts = contentParser.parse()
        posts.sort { $0.date! > $1.date! }
    }
    
    func findPost(url: URL) -> Item? {
        var foundPost: Item?
        if let postUrl = URL(string: String(url.absoluteString.dropFirst())) {
            foundPost = posts.first(where: { $0.name == postUrl.pathComponents.last! })
        }
        return foundPost
    }
}

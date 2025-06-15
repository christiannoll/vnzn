import Foundation
import SwiftUI

actor RandomColors {

    static let colors: [Color] = [.pink, .blue, .yellow, .green, .red, .gray, .indigo, .orange, .purple, .teal]

    nonisolated(unsafe) private static var indices: [Int: [Int]] = [:]

    static func color(for hashValue: Int, index: Int) -> Color {
        if var indicesForPost = indices[hashValue] {
            if index < indicesForPost.count {
                return colors[indicesForPost[index]]
            } else {
                let newIndex = Int.random(in: 0 ..< colors.count)
                indicesForPost.append(newIndex)
                indices[hashValue] = indicesForPost
                return colors[newIndex]
            }
        } else {
            let newIndex = Int.random(in: 0 ..< colors.count)
            indices[hashValue] = [newIndex]
            return colors[newIndex]
        }
    }
}

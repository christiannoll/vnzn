import Foundation
import SwiftUI

actor RandomColors {

    static let colors: [Color] = [.pink, .blue, .yellow, .green, .red, .gray, .indigo, .orange, .purple, .teal]

    nonisolated(unsafe) private static var _indices: [Int: [Int]] = [:]

    static func color(for hashValue: Int, index: Int) -> Color {
        color(for: hashValue, indices: &_indices, index: index, _colors: colors)
    }

    static func color(for hashValue: Int, indices: inout [Int: [Int]], index: Int, _colors: [Color]) -> Color {
        if var indicesForPost = indices[hashValue] {
            if index < indicesForPost.count {
                return _colors[indicesForPost[index]]
            } else {
                let newIndex = Int.random(in: 0 ..< _colors.count)
                indicesForPost.append(newIndex)
                indices[hashValue] = indicesForPost
                return _colors[newIndex]
            }
        } else {
            let newIndex = Int.random(in: 0 ..< _colors.count)
            indices[hashValue] = [newIndex]
            return _colors[newIndex]
        }
    }
}

actor RandomBlueColors {

    static let blueColors: [Color] = [.blue, .indigo, .teal, .mint]

    nonisolated(unsafe) private static var _indices: [Int: [Int]] = [:]

    static func color(for hashValue: Int, index: Int) -> Color {
        RandomColors.color(for: hashValue, indices: &_indices, index: index, _colors: blueColors)
    }
}

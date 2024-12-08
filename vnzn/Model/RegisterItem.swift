import Foundation
import UIKit

class RegisterItem : PostListItem, Identifiable, Hashable {
    
    private let _content: String
 
    init(_ content: String) {
        self._content = content
    }
    
    var content: String {
        get { return _content }
    }

    func getStyleAttributeText() -> AttributedString {
        let fontSizeText = /*numberOfPosts < 10 ?*/ numberOfPosts + 10 //: Int(Double(numberOfPosts + 10) / 10.0)

        let color = FormatBuilder.randomColors[Int.random(in: 0 ..< FormatBuilder.randomColors.count)]

        var attribuedString = AttributedString(_content)
        attribuedString.font = UIFont.systemFont(ofSize: CGFloat(fontSizeText))
        attribuedString.foregroundColor = color

        return attribuedString
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(_content)
    }
}

extension RegisterItem: Equatable {}

func ==(lhs: RegisterItem, rhs: RegisterItem) -> Bool {
    lhs.content == rhs.content
}

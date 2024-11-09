import Foundation

enum MarkdownToken {
    case end
    case tab
    case newline
    case escape
    case text(String)
    case olistDelimiter(UnicodeScalar)
    case ulistDelimiter(UnicodeScalar)
    case leftDelimiter(UnicodeScalar)
    case rightDelimiter(UnicodeScalar)
}

extension MarkdownToken: Equatable {}

extension MarkdownToken: CustomStringConvertible {
    var description: String {
        switch self {
        case .end:
            return ""
        case .escape:
            return ""
        case .tab:
            fallthrough
        case .newline:
            return "\n"
        case .text(let value):
            return value
        case .olistDelimiter(let value):
            return String(value)
        case .ulistDelimiter(let value):
            return String(value)
        case .leftDelimiter(let value):
            return String(value)
        case .rightDelimiter(let value):
            return String(value)
        }
    }
}


extension CharacterSet {
    static let delimiters = CharacterSet(charactersIn: "[](){}*_`<>")
    static let ulistDelimiters = CharacterSet(charactersIn: "*-+")
    static let olistDelimiters = CharacterSet(charactersIn: "0123456789")
    static let leftBraces = CharacterSet(charactersIn: "[({<")
    static let rightBraces = CharacterSet(charactersIn: "])}>")
    static let whitespaceAndPunctuation = CharacterSet.whitespacesAndNewlines
        .union(CharacterSet.punctuationCharacters)
    
    static func getLeftDelimiter(rightDelimiter: UnicodeScalar) -> UnicodeScalar {
        switch(rightDelimiter) {
        case ")":
            return "("
        case "]":
            return "["
        case "}":
            return "{"
        case ">":
            return "<"
        default:
            return " "
        }
    }
    
    static func isTab(_ c: UnicodeScalar) -> Bool {
        if c == UnicodeScalar.space {
            return false
        }
        
        return CharacterSet.whitespacesAndNewlines.contains(c)
    }
}

private extension UnicodeScalar {
    static let space: UnicodeScalar = " "
    static let tab: UnicodeScalar = "\t"
    static let point: UnicodeScalar = "."
    static let backslash: UnicodeScalar = "\\"
}


class MarkdownTokenizer {
    
    private let input: String.UnicodeScalarView
    private var currentIndex: String.UnicodeScalarView.Index
    private var leftDelimiters: [UnicodeScalar] = []
    
    public init(string: String) {
        input = string.unicodeScalars
        currentIndex = string.unicodeScalars.startIndex
    }
    
    func nextToken() -> MarkdownToken? {
        guard let c = current else {
            return .end
        }
        
        var token: MarkdownToken?
        
        if CharacterSet.delimiters.contains(c) {
            token = scan(delimiter: c)
            if token == nil && CharacterSet.ulistDelimiters.contains(c) {
                token = scanUnorderedList(delimiter: c)
            }
        }
        else if CharacterSet.ulistDelimiters.contains(c) {
            token = scanUnorderedList(delimiter: c)
        }
        else if CharacterSet.olistDelimiters.contains(c) {
            token = scanOrderedList(delimiter: c)
        }
        else if c == UnicodeScalar.tab {
            token = .tab
            advance()
        }
        else if c == UnicodeScalar.backslash {
            token = scanNewline()
            if token == nil {
                token = .escape
                advance()
            }
        }
        else {
            token = scanText()
        }
        
        if token == nil {
            token = .text(String(c))
            advance()
        }
        
        return token
    }
    
    private var current: UnicodeScalar? {
        guard currentIndex < input.endIndex else {
            return nil
        }
        return input[currentIndex]
    }
    
    private var previous: UnicodeScalar? {
        guard currentIndex > input.startIndex else {
            return nil
        }
        let index = input.index(before: currentIndex)
        return input[index]
    }
    
    private var next: UnicodeScalar? {
        guard currentIndex < input.endIndex else {
            return nil
        }
        let index = input.index(after: currentIndex)
        guard index < input.endIndex else {
            return nil
        }  
        return input[index]
    }
    
    private var nextnext: UnicodeScalar? {
        guard currentIndex < input.endIndex else {
            return nil
        }
        let index = input.index(after: currentIndex)
        guard index < input.endIndex else {
            return nil
        }
        let nextIndex = input.index(after: index)
        guard nextIndex < input.endIndex else {
            return nil
        }
        return input[nextIndex]
    }
    
    private var atBeginOfLine: Bool {
        guard currentIndex > input.startIndex else {
            return true
        }
        var index = input.index(before: currentIndex)
        while index > input.startIndex {
            let c = input[index]
            if c == .tab {
                return true
            }
            if !CharacterSet.whitespaceAndPunctuation.contains(c) {
                return false
            }
            index = input.index(before: index)
        }
        return true
    }
    
    private func scan(delimiter d: UnicodeScalar) -> MarkdownToken? {
        return scanRight(delimiter: d) ?? scanLeft(delimiter: d)
    }
    
    private func scanLeft(delimiter: UnicodeScalar) -> MarkdownToken? {
        let p = previous ?? .space
        
        guard let n = next else {
            return nil
        }
        
        // Left delimiters must be predeced by whitespace or punctuation
        // and NOT followed by whitespaces or newlines
        guard ((CharacterSet.whitespaces.contains(p) || CharacterSet.delimiters.contains(p)) &&
            !CharacterSet.whitespacesAndNewlines.contains(n) &&
            !leftDelimiters.contains(delimiter)) || CharacterSet.leftBraces.contains(delimiter) else {
                return nil
        }
        
        leftDelimiters.append(delimiter)
        advance()
        
        return .leftDelimiter(delimiter)
    }
    
    private func scanRight(delimiter: UnicodeScalar) -> MarkdownToken? {
        guard let p = previous else {
            return nil
        }
        
        let n = next ?? .space
                
        // Right delimiters must NOT be preceded by whitespace and must be
        // followed by whitespace or punctuation
        guard (!CharacterSet.whitespacesAndNewlines.contains(p) &&
            CharacterSet.whitespaceAndPunctuation.contains(n) &&
            delimiter != n || CharacterSet.rightBraces.contains(delimiter)) &&
            (leftDelimiters.contains(delimiter) || leftDelimiters.contains(CharacterSet.getLeftDelimiter(rightDelimiter:delimiter))) else {
                return nil
        }
        
        while !leftDelimiters.isEmpty {
            let lastLeftDelimiter = leftDelimiters.popLast()
            if lastLeftDelimiter == delimiter || lastLeftDelimiter == CharacterSet.getLeftDelimiter(rightDelimiter:delimiter) {
                break
            }
        }
        advance()
        
        return .rightDelimiter(delimiter)
    }
    
    private func scanOrderedList(delimiter: UnicodeScalar) -> MarkdownToken? {
        guard atBeginOfLine else {
            return nil
        }
        let p = previous ?? .space
        let index = currentIndex
        
        if p == UnicodeScalar.backslash {
            return nil
        }
        
        while CharacterSet.olistDelimiters.contains(next ?? .space) {
            advance()
        }
        
        let n = next ?? .space
        let nn = nextnext ?? .space
        
        guard CharacterSet.olistDelimiters.contains(delimiter) && n == .point && nn == .space else {
            currentIndex = index
            return nil
        }
        
        advance()
        advance()
        advance()
        
        return .olistDelimiter(delimiter)
    }
    
    private func scanUnorderedList(delimiter: UnicodeScalar) -> MarkdownToken? {
        guard atBeginOfLine else {
            return nil
        }
        
        let n = next ?? .space
        let nn = nextnext ?? .space
        
        guard CharacterSet.ulistDelimiters.contains(delimiter) && n == .space && !CharacterSet.ulistDelimiters.contains(nn) && nn != .space else {
                return nil
        }
        
        advance()
        advance()
        
        return .ulistDelimiter(delimiter)
    }
    
    private func scanNewline() -> MarkdownToken? {
        let n = next ?? .space
        
        guard n == .space else {
            return nil
        }
        
        advance()
        return .newline
    }

    private func scanText() -> MarkdownToken? {
        let startIndex = currentIndex
        scanUntil { CharacterSet.delimiters.contains($0) || UnicodeScalar.tab == $0 || CharacterSet.olistDelimiters.contains($0) || CharacterSet.ulistDelimiters.contains($0)
            || UnicodeScalar.backslash == $0
        }
        
        guard currentIndex > startIndex else {
            return nil
        }
        
        return .text(String(input[startIndex ..< currentIndex]))
    }
    
    private func scanUntil(_ predicate: (UnicodeScalar) -> Bool) {
        while currentIndex < input.endIndex && !predicate(input[currentIndex]) {
            advance()
        }
    }
 
    private func advance() {
        currentIndex = input.index(after: currentIndex)
    }
}

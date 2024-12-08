import Foundation

class RegisterItem : PostListItem, Identifiable, Hashable {
    
    private let _content: String
 
    init(_ content: String) {
        self._content = content
    }
    
    var content: String {
        get { return _content }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(_content)
    }
}

extension RegisterItem: Equatable {}

func ==(lhs: RegisterItem, rhs: RegisterItem) -> Bool {
    lhs.content == rhs.content
}

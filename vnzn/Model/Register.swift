import Foundation

@Observable
class Register {

    var registerItems: [RegisterItem] = []
    
    func sort() {
        registerItems.sort { $0.content < $1.content }
    }
    
    func getRegisterItems(_ postRegisterItems: Set<String>) -> [RegisterItem] {
        var _registerItems: [RegisterItem] = []
        for postRegisterItem in postRegisterItems {
            var found = false
            for registerItem in registerItems {
                if postRegisterItem == registerItem.content {
                    _registerItems.append(registerItem)
                    found = true
                }
            }
            if !found {
                let registerItem = RegisterItem(postRegisterItem)
                registerItems.append(registerItem)
                _registerItems.append(registerItem)
            }
        }
        return _registerItems
    }
}

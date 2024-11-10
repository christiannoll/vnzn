import Foundation

struct NodeParser {
    
    public func parse(_ text: String) -> [[MarkdownNode]] {
        var index = 0
        var nodesArray = [[MarkdownNode]]()
        var currentNodes: [MarkdownNode] = []
        //nodesArray.append(currentNodes)
        
        let markdownNodes = MarkdownParser.parse(text: text)
        
        for markDownNode in markdownNodes {
            switch markDownNode {
            case .linebreak:
                if currentNodes.count > 0 {
                    currentNodes.append(markDownNode)
                }
            case .newline:
                currentNodes.append(markDownNode)
            case .text(_):
                currentNodes.append(markDownNode)
            case .bold(_):
                currentNodes.append(markDownNode)
            case .italic(_):
                currentNodes.append(markDownNode)
            case .code(_):
                currentNodes.append(markDownNode)
            case .color(_, _):
                currentNodes.append(markDownNode)
            case .parenthesis(_):
                currentNodes.append(markDownNode)
            case .brackets(_):
                currentNodes.append(markDownNode)
            case .curlybraces(_):
                nodesArray.append(currentNodes)
                currentNodes = []
                currentNodes.append(markDownNode)
                nodesArray.append(currentNodes)
                currentNodes = []
            case .olistelement(_):
                currentNodes.append(markDownNode)
            case .ulistelement(_):
                currentNodes.append(markDownNode)
            case .link(_):
                currentNodes.append(markDownNode)
            case .htmlelement(_):
                currentNodes.append(markDownNode)
            case .ulist(_):
                nodesArray.append(currentNodes)
                currentNodes = []
                currentNodes.append(markDownNode)
                nodesArray.append(currentNodes)
                currentNodes = []
                if index < markdownNodes.count - 1 {
                    currentNodes.append(.linebreak)
                }
            case .olist(_):
                nodesArray.append(currentNodes)
                currentNodes = []
                currentNodes.append(markDownNode)
                nodesArray.append(currentNodes)
                currentNodes = []
                if index < markdownNodes.count - 1 {
                    currentNodes.append(.linebreak)
                }
            }
            index += 1
        }
        nodesArray.append(currentNodes)
        return nodesArray
    }
}

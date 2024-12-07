import Foundation

struct LinkParser {
    
    func parse(_ markdownNodes: [MarkdownNode], _ links: inout [String: String]) {
        for markDownNode in markdownNodes {
            switch markDownNode {
            case .bold(let nodes):
                parse(nodes, &links)
            case .italic(let nodes):
                parse(nodes, &links)
            case .code(let nodes):
                parse(nodes, &links)
            case .parenthesis(let nodes):
                parse(nodes, &links)
            case .brackets(let nodes):
                parse(nodes, &links)
            case .olistelement(let nodes):
                parse(nodes, &links)
            case .ulistelement(let nodes):
                parse(nodes, &links)
            case .link(let nodes):
                var strings: [String] = []
                parseLink(nodes, &strings)
                if strings.count == 2 {
                    links[strings[0]] = strings[1]
                }
            case .ulist(let nodes):
                parse(nodes, &links)
            case .olist(let nodes):
                parse(nodes, &links)
            default:
                break
            }
        }
    }
    
    private func parseLink(_ markdownNodes: [MarkdownNode], _ strings: inout [String]) {
        for markDownNode in markdownNodes {
            switch markDownNode {
            case .parenthesis(let nodes):
                strings.append(parseLinkText(nodes))
            case .brackets(let nodes):
                strings.append(parseLinkText(nodes))
            default:
                break
            }
        }
    }
    
    private func parseLinkText(_ markdownNodes: [MarkdownNode]) -> String {
        var s = ""
        for markDownNode in markdownNodes {
            switch markDownNode {
            case .text(let text):
                s.append(text)
            default:
                break
            }
        }
        return s
    }
}

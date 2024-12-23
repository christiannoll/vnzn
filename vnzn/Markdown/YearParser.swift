import Foundation

struct YearParser {
    
    func parse(_ markdownNodes: [MarkdownNode], _ years: inout [Int]) {
        for markDownNode in markdownNodes {
            switch markDownNode {
            case .bold(let nodes):
                parseYear(nodes, &years)
            case .code(let nodes),
                 .italic(let nodes),
                 .olist(let nodes),
                 .ulist(let nodes),
                 .olistelement(let nodes),
                 .ulistelement(let nodes),
                 .parenthesis(let nodes),
                 .brackets(let nodes),
                 .link(let nodes),
                 .color(_, let nodes):
                parse(nodes, &years)
            default:
                break
            }
        }
                
    }
    
    private func parseYear(_ markdownNodes: [MarkdownNode], _ years: inout [Int]) {
        var s = ""
        for markDownNode in markdownNodes {
            switch markDownNode {
            case .text(let text):
                s.append(text)
            default:
                break
            }
        }
        let year = parseYear(text: s)
        if year > -1 {
            years.append(year)
        }
    }
    
    private func parseYear(text: String) -> Int {
        var year = -1

        if text.count == 4  {
            year = Int(text) ?? -1
        } else {
            if let date = Date.parseDate(text) {
                year = Calendar.current.dateComponents([.year], from: date).year ?? -1
            }
        }
        return year
    }
}

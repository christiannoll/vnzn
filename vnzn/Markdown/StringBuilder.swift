import Foundation

class StringBuilder {
    
    private var firstListElement = false
    private var afterLinebreak = false
    private var oListNumber = 1
    
    func parse(_ markdownNodes: [MarkdownNode]) -> AttributedString {
        var s = AttributedString()
        for markDownNode in markdownNodes {
            switch markDownNode {
            case .linebreak:
                //s.append(AttributedString("</p>\n\t\t<p>"))
                s.append(AttributedString("\n\n"))
            case .newline:
                s.append(AttributedString("\n"))
                afterLinebreak = true
            case .text(let text):
                if afterLinebreak {
                    s.append(AttributedString(text.drop(while: { $0.isWhitespace })))
                } else {
                    s.append(AttributedString(text))
                }
            case .bold(let nodes):
                //s.append(AttributedString("<strong>"))
                var b = parse(nodes)
                b.font = .body.bold()
                s.append(b)
                //s.append(AttributedString("</strong>"))
            case .italic(let nodes):
                var i = parse(nodes)
                i.font = .body.italic()
                s.append(i)
            case .code(let nodes):
                //s.append(AttributedString("<code>"))
                //s.append(parseCode(nodes))
                var code = parseCode(nodes)
                code.font = .body.monospaced()
                s.append(code)
            case .color(let color, let nodes):
                s.append(AttributedString("<span style=\"color:" + color + "\">"))
                s.append(parse(nodes))
                s.append(AttributedString("</span>"))
            case .parenthesis(let nodes):
                s.append(AttributedString("("))
                s.append(parse(nodes))
                s.append(AttributedString(")"))
            case .brackets(let nodes):
                s.append(AttributedString("["))
                s.append(parse(nodes))
                s.append(AttributedString("]"))
            case .curlybraces(let nodes):
                /*s.append(AttributedString("<div style=\"text-align:center\">"))
                s.append(parse(nodes))
                s.append(AttributedString("</div>"))*/
                s.append(parse(nodes))
            case .olistelement(let nodes):
                var lb = AttributedString(firstListElement ? "" : "\n\n")
                lb.font = .systemFont(ofSize: 6)
                let li = lb + AttributedString("  \(oListNumber). ") + parse(nodes)
                firstListElement = false
                oListNumber += 1
                s.append(li)
                //s.append(AttributedString("</li>"))
            case .ulistelement(let nodes):
                var lb = AttributedString(firstListElement ? "" : "\n\n")
                lb.font = .systemFont(ofSize: 6)
                let li = lb + AttributedString("  • ") + parse(nodes)
                firstListElement = false
                /*let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.paragraphSpacing = 40

                let attributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: UIColor.red,
                    .paragraphStyle: paragraphStyle
                ]*/
                //let attributedString = NSAttributedString(string: "• Text\n", attributes: attributes)
                //li.setAttributes(AttributeContainer(attributes))
                s.append(li)
            case .link(let nodes):
                s.append(parseLink(nodes))
            case .ulist(let nodes):
                //s.append(AttributedString("<ul>"))
                firstListElement = true
                s.append(parse(nodes))
                //s.append(AttributedString("</ul>"))
            case .olist(let nodes):
                //s.append(AttributedString("<ol>"))
                firstListElement = true
                s.append(parse(nodes))
                oListNumber = 1
                //s.append(AttributedString("</ol>"))
            case .htmlelement(let name):
                if name == "sup" {
                    s.append(AttributedString("^("))
                } else if name == "/sup" {
                    s.append(AttributedString(")"))
                } else {
                    s.append(AttributedString(name))
                }
            }
        }
        return s
    }
    
    private func parseLink(_ markdownNodes: [MarkdownNode]) -> AttributedString {
        var s = AttributedString()
        for markDownNode in markdownNodes.reversed() {
            switch markDownNode {
            case .text(let text):
                s.append(AttributedString(text))
            case .parenthesis(let nodes):
                //s.append(AttributedString("<a href=\""))
                let url = URL(string: Self.buildUrl(parse(nodes)))
                s.link = url!
                //s.append(AttributedString("\">"))
            case .brackets(let nodes):
                s.append(parse(nodes))
                //s.append(AttributedString("</a>"))
            default:
                break
            }
        }
        return s
    }
    
    private func parseCode(_ markdownNodes: [MarkdownNode]) -> AttributedString {
        var s = AttributedString()
        for markDownNode in markdownNodes {
            switch markDownNode {
            case .linebreak:
                s.append(AttributedString("\n"))
            case .text(let text):
                s.append(AttributedString(text))
            default:
                s.append(parse([markDownNode]))
            }
        }
        return s
    }
    
    private static func buildUrl(_ urlString: AttributedString) -> String {
        /*if urlString.starts(with: "#") {
            return urlString.replaceFirst(of: "#", with: Page.baseUrl)
        }*/
        return String(urlString.characters)
    }
}

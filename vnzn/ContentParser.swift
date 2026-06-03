import Foundation
import OSLog

class ContentParser : NSObject, XMLParserDelegate {
    
    private let CONTENT_FILE =  "xml/content.xml"
    
    private var items: [Item] = []
    private var item = Item(-1)
    private var foundCharacters = ""
    private var indexType = ""

    private let logger = Logger(subsystem: "de.vnzn.vnzn", category: "ContentParser")

    func parse() -> [Item] {
        return parse(CONTENT_FILE)
    }
    
    func parse(_ filePath: String) -> [Item] {
        let xmlString = readXmlFile(filePath)
        let xmlData = xmlString.data(using: String.Encoding.utf8)!
        let parser = XMLParser(data: xmlData)
        parser.delegate = self;
        parser.parse()
        return items
    }
    
    func parse(xmlString: String) -> [Item] {
        let xmlData = xmlString.data(using: String.Encoding.utf8)!
        let parser = XMLParser(data: xmlData)
        parser.delegate = self;
        parser.parse()
        return items
    }
    
    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:]) {
        switch elementName {
        case "item":
            if let classAttrVal = attributeDict["type"] {
                if classAttrVal == "text" {
                    let textItem = TextPost(items.count + 1)
                    if let classAttrVal = attributeDict["format"] {
                        textItem.format = classAttrVal
                    }
                    item = textItem
                }
                else if classAttrVal == "image" {
                    let imageItem = ImagePost(items.count + 1)
                    if let classAttrVal = attributeDict["width"] {
                        imageItem.width = Int(classAttrVal)!
                    }
                    if let classAttrVal = attributeDict["height"] {
                        imageItem.height = Int(classAttrVal)!
                    }
                    
                    item = imageItem
                }
            }
        case "i":
            if let classAttrVal = attributeDict["type"] {
                indexType = classAttrVal
            }
            else {
                indexType = ""
            }
            break
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) {
        let trimmedText = foundCharacters.trimmingCharacters(in: .whitespacesAndNewlines)
        switch elementName {
        case "name":
            item.name = trimmedText
        case "title":
            item.title = trimmedText
        case "data":
            item.data = trimmedText
        case "date":
            item.date = parseDate(trimmedText)
        case "t":
            item.tags.insert(trimmedText)
        case "i":
            item.indices.insert(trimmedText)
            if isPersonIndex(indexType) {
                item.persons.insert(trimmedText)
            }
            else if isMovieIndex(indexType) {
                item.movies.insert(trimmedText)
            }
            else if isBookIndex(indexType) {
                item.books.insert(trimmedText)
            }
        case "serial":
            item.serials.insert(trimmedText)
        case "item":
            items.append(item)
        default:
            break
        }
        
        foundCharacters = ""
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.foundCharacters += string.replacingOccurrences(of: "\n", with: "", options: NSString.CompareOptions.literal, range:nil)
            //.replacingOccurrences(of: "\t", with: "", options: NSString.CompareOptions.literal, range:nil)
    }
    
    private func readXmlFile(_ filePath: String) -> String {
        var xmlString = ""
        
        do {
            xmlString = try String(contentsOf: Bundle.main.url(forResource: "content", withExtension: "xml")!, encoding: .utf8)
            //xmlString = try String(contentsOf: URL(fileURLWithPath: filePath))
        }
        catch {
            logger.error("Error: \(error)")
        }
        return xmlString
    }
    
    private func parseDate(_ dateString: String) -> Date? {
        return Date.parseDate(dateString)
    }
    
    private func isPersonIndex(_ typeString: String) -> Bool {
        let validStrings = ["Person", "Musiker", "Physiker", "Philosoph", "Komponist"]
        return validStrings.contains(typeString)
    }
    
    private func isMovieIndex(_ typeString: String) -> Bool {
        let validStrings = ["Movie"]
        return validStrings.contains(typeString)
    }
    
    private func isBookIndex(_ typeString: String) -> Bool {
        let validStrings = ["Book"]
        return validStrings.contains(typeString)
    }
}

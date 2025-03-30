import Foundation

@Observable
class SiteStatistics {

    var data = StatisticData()

    @MainActor
    func createStatistics(_ posts: [Post], index: Index, tags: Tags, serials: Serials) async {
        data.numberOfPosts = posts.count
        var numberOfAllLinks = 0
        var numberOfTextPosts = 0
        var numberOfAllWords = 0
        
        for post in posts {
            var postData = PostStatisticData(postItem: post)
            if post.type == .image &&
                (post.tags.contains("Foto") || post.tags.contains("Photo")
                 || post.tags.contains("Digital Art")) {
                data.numberOfImages += 1
                postData.imagePost = true
            }
            else {
                let markdownNodes = MarkdownParser.parse(text: post.data)
                parseLinks(post, markdownNodes)
                parseYears(post, markdownNodes)
                postData.wordCount = parseNumberOfWords(markdownNodes)
                postData.linkCount = post.links.count
                numberOfAllLinks += postData.linkCount
                numberOfTextPosts += 1
                numberOfAllWords += postData.wordCount
            }
            postData.publishDate = convertDateToString(post)
            postData.serialPost = post.serials.count > 0
            postData.visits = post.visits
            data.postsData.append(postData)
            data.numberOfAllLinks = numberOfAllLinks
        }

        if numberOfTextPosts > 0 {
            data.meanNumberOfLinks = numberOfAllLinks / numberOfTextPosts
            data.meanNumberOfWords = numberOfAllWords / numberOfTextPosts
        }

        data.numberOfIndexItems = index.numberOfIndexItems
        data.numberOfTagItems = tags.numberOfTagItems
        data.numberOfSerialItems = serials.numberOfTagItems
        
        sortByWordCount()
        calculateMaxWordCountPost()
        calculateMinWordCountPost()
        
        sortByLinkCount()
        calculateMaxLinkCountPost()

        sortByVisits()
        calculateMaxVisitsCountPost()
    }

    private func parseLinks(_ post: Post, _ markdownNodes: [MarkdownNode]) {
        let linkParser = LinkParser()
        var links: [String: String] = [:]
        linkParser.parse(markdownNodes, &links)
        post.links = links
    }

    private func parseYears(_ post: Post, _ markdownNodes: [MarkdownNode]) {
        let yearParser = YearParser()
        var years: [Int] = []
        yearParser.parse(markdownNodes, &years)
        post.years = years
    }

    private func convertDateToString(_ post: Post) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.locale = Locale.init(identifier: "de_DE")
        
        return dateFormatter.string(from: post.date!)
    }
    
    private func parseNumberOfWords(_ markdownNodes: [MarkdownNode]) -> Int {
        var numberOfWords = 0
        for markDownNode in markdownNodes {
            switch markDownNode {
            case .text(let text):
                let words = text.components(separatedBy: CharacterSet.whitespaceAndPunctuation)
                for word in words {
                    if word.count > 1 {
                        numberOfWords += 1
                    }
                }
            case .bold(let nodes):
                numberOfWords += parseNumberOfWords(nodes)
            case .italic(let nodes):
                numberOfWords += parseNumberOfWords(nodes)
            case .code(let nodes):
                numberOfWords += parseNumberOfWords(nodes)
            case .color(_, let nodes):
                numberOfWords += parseNumberOfWords(nodes)
            case .parenthesis(let nodes):
                numberOfWords += parseNumberOfWords(nodes)
            case .brackets(let nodes):
                numberOfWords += parseNumberOfWords(nodes)
            case .olistelement(let nodes):
                numberOfWords += parseNumberOfWords(nodes)
            case .ulistelement(let nodes):
                numberOfWords += parseNumberOfWords(nodes)
            case .link(let nodes):
                numberOfWords += parseNumberOfWordsInLink(nodes)
            case .ulist(let nodes):
                numberOfWords += parseNumberOfWords(nodes)
            case .olist(let nodes):
                numberOfWords += parseNumberOfWords(nodes)
            default:
                break
            }
        }
        return numberOfWords
    }
    
    private func parseNumberOfWordsInLink(_ markdownNodes: [MarkdownNode]) -> Int {
        var numberOfWords = 0
        for markDownNode in markdownNodes {
            switch markDownNode {
            case .brackets(let nodes):
                numberOfWords += parseNumberOfWords(nodes)
            default:
                break
            }
        }
        return numberOfWords
    }
    
    private func calculateMaxWordCountPost() {
        if !data.postsData.isEmpty {
            data.maxWordCountPostItem = StatisticPostItem(data.postsData.last!.postItem, data.postsData.last!.wordCount)
        }
    }
    
    private func calculateMinWordCountPost() {
        for postStatisticData in data.postsData {
            if postStatisticData.wordCount > 0 {
                data.minWordCountPostItem = StatisticPostItem(postStatisticData.postItem, postStatisticData.wordCount)
                break
            }
        }
    }
    
    private func calculateMaxLinkCountPost() {
        if !data.postsData.isEmpty {
            data.maxLinkCountPostItem = StatisticPostItem(data.postsData.last!.postItem, data.postsData.last!.linkCount)
        }
    }

    private func calculateMaxVisitsCountPost() {
        if !data.postsData.isEmpty {
            data.maxVisitsPostItem = StatisticPostItem(data.postsData.last!.postItem, data.postsData.last!.visits)
        }
    }

    private func sortByWordCount() {
        data.postsData.sort { $0.wordCount < $1.wordCount }
    }
    
    private func sortByLinkCount() {
        data.postsData.sort { $0.linkCount < $1.linkCount }
    }

    private func sortByVisits() {
        data.postsData.sort { $0.visits < $1.visits }
    }
}

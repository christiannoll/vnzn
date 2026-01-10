import Foundation

@Observable
class Archive {
    
    var years: [ArchiveYear] = []

    @MainActor
    private func addPost(_ post: Post) async {
        if let year = getYear(post) {
            year.addPost(post)
        }
    }

    @MainActor
    func createArchive(_ posts: [Post]) async {
        for post in posts {
            await addPost(post)
        }
    }

    private func getYear(_ post: Post) -> ArchiveYear? {
        for year in years {
            if let date = post.date {
                let comps = Calendar.current.dateComponents([.year], from: date)
                if comps.year! == year.year {
                    return year
                }
            }
        }
        return createYear(post)
    }

    private func createYear(_ post: Post) -> ArchiveYear? {
        guard let date = post.date else {
            //assert(false , "Post without date")
            return nil
        }

        let comps = Calendar.current.dateComponents([.year], from: date)
        let year = ArchiveYear(comps.year!)
        years.append(year)
        return year
    }
}

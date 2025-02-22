import Foundation

class Archive {
    
    var years: [ArchiveYear] = []

    @MainActor
    private func addPost(_ post: Post) async {
        let year = getYear(post)
        year.addPost(post)
    }

    @MainActor
    func createArchive(_ posts: [Post]) async {
        for post in posts {
            await addPost(post)
        }
    }

    private func getYear(_ post: Post) -> ArchiveYear {
        for year in years {
            let comps = Calendar.current.dateComponents([.year], from: post.date!)
            if comps.year! == year.year {
                return year
            }
        }
        return createYear(post)
    }
    
    private func createYear(_ post: Post) -> ArchiveYear {
        let comps = Calendar.current.dateComponents([.year], from: post.date!)
        let year = ArchiveYear(comps.year!)
        years.append(year)
        return year
    }
}

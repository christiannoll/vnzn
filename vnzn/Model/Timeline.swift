import Foundation

@Observable
class Timeline {

    var timelineItems: [TimelineItem] = []

    func createTimeline(_ posts: [Post]) async {
        for post in posts {
            addPost(post)
        }

        timelineItems.sort { $0.year < $1.year }
    }
    
    private func addPost(_ post: Post) {
        for timelineItem in getTimelineItems(post) {
            timelineItem.addPost(post)
        }
    }
    
    private func getTimelineItems(_ post: Post) -> [TimelineItem] {
        var _timelineItems: [TimelineItem] = []
        for year in post.years {
            var found = false
            for timelineItem in timelineItems {
                if year == timelineItem.year {
                    _timelineItems.append(timelineItem)
                    found = true
                }
            }
            if !found {
                let timelineItem = TimelineItem(year)
                _timelineItems.append(timelineItem)
                timelineItems.append(timelineItem)
            }
        }
        return _timelineItems
    }
}

import Foundation
import SwiftData

@MainActor
let appContainer: ModelContainer = {
    do {
        let container = try ModelContainer(for: Post.self)
        
        /*let post = Post(id: 0, title: "Hello")
        post.metaInfo.isFavourite = true
        container.mainContext.insert(post)
        var postFetchDescriptor = FetchDescriptor<Post>()
        var loadedPosts = try container.mainContext.fetch(postFetchDescriptor)
        
        for loadedPost in loadedPosts {
            print("id: \(loadedPost.id), title: \(loadedPost.title), isFavourite: \(loadedPost.metaInfo.isFavourite)")
        }
        
        post.title = "Second"
        try container.mainContext.save()*/
        
        
        Task {
            let lastUpdateKey = "lastUpdate"
            let lastUpdateFromServer = await fetchLastUpdate()
            
            
            let lastUpdateLocal = UserDefaults.standard.double(forKey: lastUpdateKey)
            if lastUpdateFromServer > lastUpdateLocal {
                let updateService = UpdateService()
                try await updateService.update(container: container)
                UserDefaults.standard.set(lastUpdateFromServer, forKey: lastUpdateKey)
            }
        }
        
        var postFetchDescriptor = FetchDescriptor<Post>()
        var loadedPosts = try container.mainContext.fetch(postFetchDescriptor)
        //loadedPosts.first?.title = "Mathe"
        
        
        for loadedPost in loadedPosts {
            print("id: \(loadedPost.id), title: \(loadedPost.title), isFavourite: \(loadedPost.metaInfo.isFavourite)")
        }
        //try container.mainContext.save()
        
        /*var itemFetchDescriptor = FetchDescriptor<Day>()
        
        let endDate = Date().getNextMonth()?.getNextMonth()?.noon
        var day = Date().getPreviousMonth()?.noon ?? Date().noon
        var loadedDays = try container.mainContext.fetch(itemFetchDescriptor)
        let settings = Settings()
        
        while day != endDate {
            var loaded = false
            for loadedDay in loadedDays {
                if loadedDay.id.hasSame(.day, as: day) {
                    loaded = true
                    break
                }
            }
            
            if !loaded {
                let newDay = Day(id: day, text: settings.weekdaysText[day.weekday - 1],
                                   fgColor: settings.weekdaysFgColor[day.weekday - 1],
                                   bgColor: settings.weekdaysBgColor[day.weekday - 1])
                container.mainContext.insert(newDay)
            }
            
            day = day.dayAfter.noon
        }
        
        var settingsFetchDescriptor = FetchDescriptor<Settings>()
        settingsFetchDescriptor.fetchLimit = 1
        
        guard try container.mainContext.fetch(settingsFetchDescriptor).count == 0 else { return container }

        container.mainContext.insert(settings)*/
        
        return container
    } catch {
        fatalError("Failed to create container")
    }
}()

func fetchLastUpdate() async -> Double {
    do {
        let fromUrl = "https://www.vnzn.de/app/last_update.txt"
        let dateString = try await Client().fetchData(fromUrl: fromUrl)
        let currentDateFormatter = DateFormatter()
        currentDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = currentDateFormatter.date(from:dateString) {
            return date.timeIntervalSince1970
        }
    } catch {
        print(error)
    }
    return 0
}

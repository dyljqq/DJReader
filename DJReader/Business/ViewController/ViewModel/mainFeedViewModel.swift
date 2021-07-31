//
//  mainFeedViewModel.swift
//  DJReader
//
//  Created by 季勤强 on 2021/7/31.
//

import Foundation

let mainFeedQueueName = "com.dyljqq.fetch.feed"

class MainFeedViewModel {
    
    var dataSource: [MainFeed] = []
    var feedSources: [FeedSource] = [.zhihu]
    
    let queue = DispatchQueue(label: mainFeedQueueName, attributes: [.concurrent])
    
    init() {
        (0..<1).forEach { _ in
            feedSources.append(.zhihu)
        }
    }
    
    func fetchFeeds(completionHandler: @escaping ([MainFeed]) -> ()) {
        let group = DispatchGroup()
        
        print("start fetching...")
        for source in feedSources {
            group.enter()
            APIClient.shared.get(source: source) { (feed: Feed?) in
                guard let feed = feed else { return }
                let mainFeed = MainFeed(feed: feed, source: source)
                self.dataSource.append(mainFeed)
                group.leave()
                
                print("end fetch: \(source.rawValue)")
            }
        }
        
        group.notify(queue: queue) {
            for mainFeed in self.dataSource {
                let mainFeedId = MainFeed.getFeedId(by: mainFeed.source)
                var feed = Feed.getByMainFeedId(mainFeedId)
                if feed == nil {
                    var f = mainFeed.feed
                    f.mainFeedId = mainFeedId
                    f.execute(.insert, sql: Feed.insertSql)
                    feed = Feed.getByMainFeedId(mainFeedId)
                }
                
                if let feedId = feed?.id {
                    FeedItem.insertFeedItems(feedId, items: mainFeed.feed.items)
                }
            }
            
            completionHandler(self.dataSource)
        }
        
    }
    
}

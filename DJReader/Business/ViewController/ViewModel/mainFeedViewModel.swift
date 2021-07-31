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
    
    let queue = DispatchQueue(label: mainFeedQueueName, attributes: [.concurrent])
    
    init() {
    }
    
    func updateDataSource(isUseLocaldata: Bool, _ completionHandler: @escaping ([MainFeed]) -> ()) {
        if isUseLocaldata {
            DispatchQueue.global().async {
                self.dataSource = self.getStoredData()
                DispatchQueue.main.async {
                    completionHandler(self.dataSource)
                }
            }
        }
        
        fetchFeeds(completionHandler)
    }
    
    func getStoredData() -> [MainFeed] {
        var feeds: [MainFeed] = []
        for source in feedSources {
            let mainFeedId = MainFeed.getFeedId(by: source)
            
            if var feed = Feed.getByMainFeedId(mainFeedId), let feedId = feed.id {
                feed.items = FeedItem.getItems(by: feedId)
                feeds.append(MainFeed(feed: feed, source: source))
            }
        }
        return feeds
    }
    
    func fetchFeeds(_ completionHandler: @escaping ([MainFeed]) -> ()) {
        var mainFeeds: [MainFeed] = []
        
        let group = DispatchGroup()
        
        print("start fetching...")
        for source in feedSources {
            group.enter()
            APIClient.shared.get(source: source) { (feed: Feed?) in
                guard let feed = feed else { return }
                let mainFeed = MainFeed(feed: feed, source: source)
                mainFeeds.append(mainFeed)
                group.leave()
                
                print("end fetch: \(source.rawValue)")
            }
        }
        
        group.notify(queue: queue) {
            for mainFeed in mainFeeds {
                let mainFeedId = MainFeed.getFeedId(by: mainFeed.source)
                var feed = Feed.getByMainFeedId(mainFeedId)
                
                if feed == nil {
                    var f = mainFeed.feed
                    f?.mainFeedId = mainFeedId
                    f?.execute(.insert, sql: Feed.insertSql)
                    feed = Feed.getByMainFeedId(mainFeedId)
                }
                
                if let feedId = feed?.id, let feed = mainFeed.feed {
                    FeedItem.insertFeedItems(feedId, items: feed.items)
                }
            }
            
            self.dataSource = mainFeeds
            completionHandler(self.dataSource)
        }
        
    }
    
}

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
    
    init() {}
    
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
    
    func updateDataSource(isUseLocalData: Bool) async {
        if isUseLocalData {
            self.dataSource = getStoredData()
        } else {
            self.dataSource = await fetchFeeds()
        }
    }
    
    func getStoredData() -> [MainFeed] {
        var feeds: [MainFeed] = []
        for source in feedSources {
            if let mainFeed = MainFeed.getMainFeed(by: source) {
                feeds.append(mainFeed)
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
                var feed = Feed.getFeed(by: mainFeedId)
                
                if feed == nil {
                    var f = mainFeed.feed
                    f?.mainFeedId = mainFeedId
                    f?.execute(.insert, sql: Feed.insertSql)
                    feed = Feed.getFeed(by: mainFeedId)
                }
                
                if let f = mainFeed.feed {
                    f.update(mainFeedId)
                }
                
                if let feedId = feed?.id, let feed = mainFeed.feed {
                    FeedItem.insertFeedItems(feedId, items: feed.items)
                }
            }
            
            self.dataSource = mainFeeds.sorted(by: { $0.source < $1.source })
            completionHandler(self.dataSource)
        }
        
    }
    
    func fetchFeeds() async -> [MainFeed] {
        var mainFeeds: [MainFeed] = []
        for source in feedSources {
            print("start parse: \(source)")
            if source.defaultFeed != nil, let feed = source.defaultFeed {
                mainFeeds.append(MainFeed(feed: feed, source: source))
                continue
            }
            let r: Result<Feed, DJError> = await APIClient.shared.get(source: source).decode()
            switch r {
            case .success(let feed):
                let mainFeed = MainFeed(feed: feed, source: source)
                mainFeeds.append(mainFeed)
            case .failure(let error):
                // 如果获取失败，则使用本地数据
                if let mainFeed = MainFeed.getMainFeed(by: source) {
                    mainFeeds.append(mainFeed)
                }
                print("fetch feeds error: \(error)")
            }
            print("end parse: \(source)")
        }
        for mainFeed in mainFeeds {
            let mainFeedId = MainFeed.getFeedId(by: mainFeed.source)
            var feed = Feed.getFeed(by: mainFeedId)
            
            if feed == nil {
                var f = mainFeed.feed
                f?.mainFeedId = mainFeedId
                f?.execute(.insert, sql: Feed.insertSql)
                feed = Feed.getFeed(by: mainFeedId)
            }
            
            if let f = mainFeed.feed {
                f.update(mainFeedId)
            }
            
            if let feedId = feed?.id, let feed = mainFeed.feed {
                FeedItem.insertFeedItems(feedId, items: feed.items)
            }
        }
        
        self.dataSource = mainFeeds.sorted(by: { $0.source < $1.source })
        return mainFeeds
    }
    
}

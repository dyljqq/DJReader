//
//  Feed.swift
//  DJReader
//
//  Created by 季勤强 on 2021/7/30.
//

import Foundation

struct Feed: Codable {
    
    let title: String
    var description: String
    let link: String
    var items: [FeedItem]
    
    var id: Int? = 0
    var mainFeedId: Int? = 0
    
}

extension Feed: SQLTable {
    static var fieldsTypeMapping: [String : FieldType] {
        return [
            "title": .text,
            "desc": .text,
            "link": .text,
            "main_feed_id": .int
        ]
    }
    
    
    static var tableName: String {
        return "feed"
    }
    
    static var fields: [String] {
        return [
            "title",
            "desc",
            "link",
            "main_feed_id"
        ]
    }
    
    var fieldsValueMapping: [String : Any] {
        return [
            "title": self.title,
            "desc": self.description,
            "link": self.link,
            "main_feed_id": self.mainFeedId ?? 0
        ]
    }
    
    static var uniqueKeys: [String] {
        return ["main_feed_id"]
    }
    
    static func convertToModel(_ hash: [String : Any]) -> Feed? {
        let title = hash["title"] as? String ?? ""
        let link = hash["link"] as? String ?? ""
        let desc = hash["desc"] as? String ?? ""
        let mainFeedId = hash["main_feed_id"] as? Int ?? 0
        let id = hash["id"] as? Int ?? 0
        
        var feed = Feed(title: title, description: desc, link: link, items: [])
        feed.id = id
        feed.mainFeedId = mainFeedId
        return feed
    }
    
    static func getByMainFeedId(_ feedId: Int) -> Feed? {
        let sql = "select * from \(tableName) where main_feed_id=\(feedId);"
        let rs = store.execute(.select, sql: sql, type: Feed.self)
        guard let first = (rs as? [[String: Any]])?.first else {
            return nil
        }
        return convertToModel(first)
    }
    
}

let defaultFeed = Feed(title: "知乎", description: "知乎日报", link: "www.zhihu.com", items: [defaultFeedItem])

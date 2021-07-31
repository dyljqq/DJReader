//
//  FeedItem.swift
//  DJReader
//
//  Created by 季勤强 on 2021/7/31.
//

import Foundation

struct FeedItem: Codable {
    
    let title: String
    let link: String
    let description: String
    let pubDate: String
    
    var feedId: Int? = 0
    
}

extension FeedItem: SQLTable {
    static var fields: [String] {
        return [
            "title",
            "link",
            "desc",
            "pub_date",
            "feed_id"
        ]
    }
    
    static var fieldsTypeMapping: [String : FieldType] {
        return [
            "title": .text,
            "link": .text,
            "desc": .text,
            "pub_date": .text,
            "feed_id": .int
        ]
    }
    
    var fieldsValueMapping: [String : Any] {
        return [
            "title": self.title,
            "link": self.link,
            "desc": self.description,
            "pub_date": self.pubDate,
            "feed_id": self.feedId ?? 0
        ]
    }
    
    static func convertToModel(_ hash: [String : Any]) -> FeedItem? {
        let title = hash["title"] as? String ?? ""
        let link = hash["link"] as? String ?? ""
        let desc = hash["desc"] as? String ?? ""
        let pubDate = hash["pub_date"] as? String ?? ""
        let feedId = hash["feed_id"] as? Int ?? 0
        
        var item = FeedItem(title: title, link: link, description: desc, pubDate: pubDate)
        item.feedId = feedId
        return item
    }
    
    static var tableName: String {
        return "feed_item"
    }
    
    static func deleteOldFeedItems(_ feedId: Int) {
        guard feedId > 0 else {
            return
        }
        
        let sql = "delete from \(tableName) where feed_id = \(feedId);"
        store.execute(.delete, sql: sql, type: FeedItem.self)
    }
    
    static func insertNewFeedItems(items: [FeedItem], feedId: Int) {
        for item in items {
            var it = item
            it.feedId = feedId
            it.insert()
        }
    }
    
    static func insertFeedItems(_ feedId: Int, items: [FeedItem]) {
        deleteOldFeedItems(feedId)
        insertNewFeedItems(items: items, feedId: feedId)
    }
    
    static func getItems(by feedId: Int) -> [FeedItem] {
        let sql = "select * from \(tableName) where feed_id = \(feedId);"
        guard let rs = store.execute(.select, sql: sql, type: FeedItem.self) as? [[String: Any]] else {
            return []
        }
        
        return rs.compactMap { convertToModel($0) }
    }
    
}

let defaultFeedItem = FeedItem(title: "知乎", link: "www.zhihu.com", description: "知乎日报", pubDate: "Fri, 30 Jul 2021 14:30:07 +0800")

//
//  FeedItem.swift
//  DJReader
//
//  Created by 季勤强 on 2021/7/31.
//

import Foundation

struct FeedItem: Decodable {
    
    let title: String
    let link: String
    let description: String
    let pubDate: String
    
    var feedId: Int = 0
    var author: String = ""
    
    init(title: String, link: String, description: String, pubDate: String) {
        self.title = title
        self.description = description
        self.link = link
        self.pubDate = pubDate
    }
    
    enum CodingKeys: String, CodingKey {
        case title, link, description, pubDate, desc, feedId, author
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        link = try container.decode(String.self, forKey: .link)
        if let description = try? container.decode(String.self, forKey: .description) {
            self.description = description
        } else {
            self.description = (try? container.decode(String.self, forKey: .desc)) ?? ""
        }
        pubDate = try container.decode(String.self, forKey: .pubDate)
        feedId = (try? container.decode(Int.self, forKey: .feedId)) ?? 0
        author = (try? container.decode(String.self, forKey: .author)) ?? ""
    }
    
}

extension FeedItem: SQLTable {
    static var fields: [String] {
        return [
            "title",
            "link",
            "desc",
            "pub_date",
            "feed_id",
            "author"
        ]
    }
    
    static var fieldsTypeMapping: [String : FieldType] {
        return [
            "title": .text,
            "link": .text,
            "desc": .text,
            "pub_date": .text,
            "feed_id": .int,
            "author": .text
        ]
    }
    
    var fieldsValueMapping: [String : Any] {
        return [
            "title": self.title,
            "link": self.link,
            "desc": self.description,
            "pub_date": self.pubDate,
            "feed_id": self.feedId,
            "author": self.author
        ]
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
        
        return rs.compactMap { decode($0) }
    }
    
}

let defaultFeedItem = FeedItem(title: "知乎", link: "www.zhihu.com", description: "知乎日报", pubDate: "Fri, 30 Jul 2021 14:30:07 +0800")

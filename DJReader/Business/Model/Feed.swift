//
//  Feed.swift
//  DJReader
//
//  Created by 季勤强 on 2021/7/30.
//

import Foundation

struct Feed: Decodable {
    
    let title: String
    var description: String
    let link: String
    var items: [FeedItem]
    
    var id: Int = 0
    var mainFeedId: Int = 0
    
    init(title: String, description: String, link: String, items: [FeedItem]) {
        self.title = title
        self.description = description
        self.link = link
        self.items = items
    }
    
    enum CodingKeys: String, CodingKey {
        case title, description, desc, id, link, items, mainFeedId
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        if let desc = try? container.decode(String.self, forKey: .description) {
            self.description = desc
        } else {
            self.description = (try? container.decode(String.self, forKey: .desc)) ?? ""
        }
        self.link = try container.decode(String.self, forKey: .link)
        self.id = (try? container.decode(Int.self, forKey: .id)) ?? 0
        self.mainFeedId = (try? container.decode(Int.self, forKey: .mainFeedId)) ?? 0
        self.items = (try? container.decode([FeedItem].self, forKey: .items)) ?? []
    }
    
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
            "main_feed_id": self.mainFeedId
        ]
    }
    
    static var uniqueKeys: [String] {
        return ["main_feed_id"]
    }
    
    static func getFeed(by mainFeedId: Int) -> Self? {
        let sql = "select * from \(tableName) where main_feed_id=\(mainFeedId);"
        guard let rs = store.execute(.select, sql: sql, type: Feed.self) as? [[String: Any]], !rs.isEmpty else {
            return nil
        }
        
        return decode(rs[0])
    }
    
    func update(_ mainFeedId: Int) {
        let feed = Feed.getFeed(by: mainFeedId)
        guard let feed = feed else {
            return
        }
        
        let sql = "update \(Self.tableName) set title=\"\(self.title)\", link=\"\(self.link)\", desc=\"\(self.description)\" where id=\(feed.id)"
        store.execute(.update, sql: sql, type: Self.self)
    }
    
}

let defaultFeed = Feed(title: "知乎", description: "知乎日报", link: "www.zhihu.com", items: [defaultFeedItem])

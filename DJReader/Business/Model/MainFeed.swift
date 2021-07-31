//
//  MainFeed.swift
//  DJReader
//
//  Created by 季勤强 on 2021/7/31.
//

import Foundation

struct MainFeed {
    var feed: Feed? = nil
    let source: FeedSource
    
    init(feed: Feed, source: FeedSource) {
        self.feed = feed
        self.source = source
    }
    
    init(source: FeedSource) {
        self.source = source
    }
}

extension MainFeed: SQLTable {
    static var tableName: String {
        return "main_feed"
    }
    
    static var fields: [String] {
        return [
            "source"
        ]
    }
    
    static var fieldsTypeMapping: [String : FieldType] {
        return [
            "source": .int
        ]
    }
    
    static var uniqueKeys: [String] {
        return ["source"]
    }
    
    var fieldsValueMapping: [String: Any] {
        return [
            "source": self.source.rawValue
        ]
    }
    
    static func getFeedId(by source: FeedSource) -> Int {
        let sql = "select * from \(tableName) where source=\(source.rawValue);"
        guard let rs = store.execute(.select, sql: sql, type: Self.self) as? [[String: Any]],
              let hash = rs.first,
              let feedId = hash["id"] as? Int32 else {
            return 0
        }
        return Int(feedId)
    }
}

let defaultMainFeed = MainFeed(feed: defaultFeed, source: .zhihu)
let zhihuMainFeed = MainFeed(feed: defaultFeed, source: .zhihu)

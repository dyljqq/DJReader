//
//  MainFeed.swift
//  DJReader
//
//  Created by 季勤强 on 2021/7/31.
//

import Foundation

struct MainFeed {
    let feed: Feed
    let source: FeedSource
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
              let first = rs.first else {
            return 0
        }
        return first["id"] as? Int ?? 0
    }
}

let defaultMainFeed = MainFeed(feed: defaultFeed, source: .zhihu)
let zhihuMainFeed = MainFeed(feed: defaultFeed, source: .zhihu)

//
//  Feed.swift
//  DJReader
//
//  Created by 季勤强 on 2021/7/30.
//

import Foundation

struct Feed: Codable {
    
    let title: String
    let description: String
    let link: String
    let items: [FeedItem]
    
}

extension Feed: SQLTable {
    
    var tableName: String {
        return "feed"
    }
    
    var tableSql: String {
        let fields = [
            "title TEXT not null default \"\"",
            "desc TEXT not null default \"\"",
            "link TEXT not null default \"\"",
        ]
        return createTableSql(fields)
    }
    
}

let defaultFeed = Feed(title: "知乎", description: "知乎日报", link: "www.zhihu.com", items: [defaultFeedItem])

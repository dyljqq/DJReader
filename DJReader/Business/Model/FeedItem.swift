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
    
}

extension FeedItem: SQLTable {
    
    var tableName: String {
        return "feed_item"
    }
    
    var tableSql: String {
        let fields = [
            "title TEXT not null default \"\"",
            "desc TEXT not null default \"\"",
            "link TEXT not null default \"\"",
            "feed_id INTEGER not null default 0",
        ]
        return createTableSql(fields)
    }
    
}

let defaultFeedItem = FeedItem(title: "知乎", link: "www.zhihu.com", description: "知乎日报", pubDate: "Fri, 30 Jul 2021 14:30:07 +0800")

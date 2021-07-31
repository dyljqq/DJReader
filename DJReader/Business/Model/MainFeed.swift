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
    
    var tableName: String {
        return "main_feed"
    }
    
    var tableSql: String {
        let fields = [
            "feed_id INTEGER not null default 0",
            "source INTEGER not null default 0",
        ]
        return createTableSql(fields)
    }
    
}

let defaultMainFeed = MainFeed(feed: defaultFeed, source: .zhihu)

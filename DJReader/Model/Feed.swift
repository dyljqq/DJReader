//
//  Feed.swift
//  DJReader
//
//  Created by 季勤强 on 2021/7/30.
//

import Foundation

struct MainFeed {
    let feed: Feed
    let source: FeedSource
}

struct Feed: Codable {
    
    let title: String
    let description: String
    let link: String
    let items: [FeedItem]
    
}

struct FeedItem: Codable {
    
    let title: String
    let link: String
    let description: String
    let pubDate: String
    
}

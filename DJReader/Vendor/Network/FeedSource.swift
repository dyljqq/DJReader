//
//  FeedSource.swift
//  DJReader
//
//  Created by 季勤强 on 2021/7/30.
//

import Foundation

enum ParseWay {
    
    case rss
    case interface
    
}

enum FeedSource {
    case zhihu
}

extension FeedSource {
    var urlString: String {
        switch self {
        case .zhihu:
            return "https://www.zhihu.com/rss"
        }
        
    }
    
    var url: URL? {
        switch self {
        case .zhihu: return URL(string: self.urlString)
        }
    }
    
}

// utils

extension FeedSource {
    
}

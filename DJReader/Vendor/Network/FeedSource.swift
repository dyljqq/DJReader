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

enum FeedSource: String, Codable {
    case zhihu
    case unknow
}

extension FeedSource {
    var urlString: String {
        switch self {
        case .zhihu: return "https://www.zhihu.com/rss"
        default: return ""
        }
        
    }
    
    var url: URL? {
        switch self {
        case .zhihu: return URL(string: self.urlString)
        default: return nil
        }
    }
    
    var imageName: String {
        return "zhihu"
    }
    
}

// utils

extension FeedSource {
    
}

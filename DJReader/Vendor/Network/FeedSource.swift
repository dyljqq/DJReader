//
//  FeedSource.swift
//  DJReader
//
//  Created by 季勤强 on 2021/7/30.
//

import Foundation

let feedSources: [FeedSource] = [.zhihu, .cnBeta]

enum ParseWay {
    
    case rss
    case interface
    
}

enum FeedSource: Int, Decodable {
    case unknow = 0
    case zhihu
    case cnBeta
    
    var parser: DJParse? {
        switch self {
        case .zhihu: return ZhihuXMLParser()
        case .cnBeta: return CnBetaXMLParser()
        case .unknow: return nil
        }
    }
}

extension FeedSource {
    var urlString: String {
        switch self {
        case .zhihu: return "https://www.zhihu.com/rss"
        case .cnBeta: return "https://www.cnbeta.com/backend.php"
        default: return ""
        }
        
    }
    
    var url: URL? {
        return URL(string: self.urlString)
    }
    
    var imageName: String {
        return "zhihu"
    }
    
}

// utils

extension FeedSource {
    
}

//
//  FeedSource.swift
//  DJReader
//
//  Created by 季勤强 on 2021/7/30.
//

import Foundation

let feedSources: [FeedSource] = [.zhihu, .cnBeta, .zhihuReport, .myzb]

func <(left: FeedSource, right: FeedSource) -> Bool {
    return left.rawValue < right.rawValue
}

enum ParseWay {
    case xml
    case json
}

enum FeedSource: Int, Decodable {
    case unknow = 0
    case zhihu
    case cnBeta
    case zhihuReport
    case myzb // 摸鱼周报
    
    var parser: DJParse? {
        guard case ParseWay.xml = parseWay else {
            return DJJSONParse()
        }
        
        switch self {
        case .zhihu: return ZhihuXMLParser()
        case .cnBeta: return CnBetaXMLParser()
        case .myzb: return MyzbXMLParser()
        default: return nil
        }
    }
}

extension FeedSource {
    
    var parseWay: ParseWay {
        switch self {
        case .zhihuReport: return .json
        default: return .xml
        }
    }
    
    var urlString: String {
        return self.router?.urlString ?? ""
    }
    
    var url: URL? {
        return URL(string: self.urlString)
    }
    
    var router: Router? {
        switch self {
        case .zhihuReport: return ZhihuReportRouter.lastNews
        case .zhihu: return GeneralRouter.zhihu
        case .cnBeta: return GeneralRouter.cnBeta
        case .myzb: return GeneralRouter.myzb
        case .unknow: return nil
        }
    }
    
    var imageName: String {
        return "zhihu"
    }
    
    var defaultFeed: Feed? {
        switch self {
        case .zhihuReport: return Feed(title: "知乎日报", description: "知乎日报 - 发现你的好奇心", link: "", items: [])
        default: return nil
        }
    }
    
}

// utils

extension FeedSource {
    
}

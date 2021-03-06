//
//  GeneralRouter.swift
//  DJReader
//
//  Created by 季勤强 on 2021/8/5.
//

import Foundation

enum GeneralRouter: Router {
    case zhihu
    case cnBeta
    case myzb
    
    var baseURLString: String {
        switch self {
        case .zhihu: return "https://www.zhihu.com/rss"
        case .cnBeta: return "https://www.cnbeta.com/backend.php"
        case .myzb: return "https://zhangferry.com/atom.xml"
        }
    }
}

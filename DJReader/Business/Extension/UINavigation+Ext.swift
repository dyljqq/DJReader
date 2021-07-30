//
//  UINavigation+Ext.swift
//  DJReader
//
//  Created by 季勤强 on 2021/7/31.
//

import UIKit

extension UINavigationController {
    
    func pushFeedViewController(feed: Feed) {
        let vc = FeedViewController(feed: feed)
        self.pushViewController(vc, animated: true)
    }
    
}

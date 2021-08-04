//
//  FeedDetailCell.swift
//  DJReader
//
//  Created by 季勤强 on 2021/7/31.
//

import UIKit

class FeedDetailCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func render(feedItem: FeedItem) {
        self.titleLabel.text = feedItem.title
        
        var desc = ""
        if let date = DateHelper.standard.dateFromRFC822String(feedItem.pubDate) {
            desc = DateHelper.standard.dateToString(date)
        } else {
            desc = feedItem.pubDate
        }
        
        self.descLabel.text = "\(desc)  \(feedItem.author)"
    }
    
}

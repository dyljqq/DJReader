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
        
        if let date = DateHelper.standard.dateFromRFC822String(feedItem.pubDate) {
            self.descLabel.text = DateHelper.standard.dateToString(date)
        } else {
            self.descLabel.text = feedItem.pubDate
        }
    }
    
}

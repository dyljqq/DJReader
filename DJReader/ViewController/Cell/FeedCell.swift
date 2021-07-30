//
//  FeedCell.swift
//  DJReader
//
//  Created by 季勤强 on 2021/7/31.
//

import UIKit

class FeedCell: UITableViewCell {
    
    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func render(feed: MainFeed) {
        self.feedImageView.image = UIImage(named: feed.source.imageName)
        self.titleLabel.text = feed.feed.title
        self.descLabel.text = feed.feed.description
    }
    
}

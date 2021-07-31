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
    
    func render(mainFeed: MainFeed) {
        guard let feed = mainFeed.feed else {
            return
        }
        
        self.feedImageView.image = UIImage(named: mainFeed.source.imageName)
        self.titleLabel.text = feed.title
        self.descLabel.text = feed.description
    }
    
}

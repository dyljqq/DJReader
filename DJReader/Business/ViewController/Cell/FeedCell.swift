//
//  FeedCell.swift
//  DJReader
//
//  Created by 季勤强 on 2021/7/31.
//

import UIKit
import Kingfisher

class FeedCell: UITableViewCell {
    
  @IBOutlet weak var feedImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descLabel: UILabel!
  @IBOutlet weak var numLabel: UILabel!

  override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func render(mainFeed: MainFeed) {
        guard let feed = mainFeed.feed else {
            return
        }
        
        feedImageView.kf.setImage(with: URL(string: mainFeed.source.imageName), placeholder: UIImage(named: mainFeed.source.imageName))
        self.titleLabel.text = feed.title
        self.descLabel.text = feed.description
      self.numLabel.text = "\(mainFeed.feed?.items.count ?? 0)"
    }
    
}

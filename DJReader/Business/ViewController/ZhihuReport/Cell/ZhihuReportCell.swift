//
//  ZhihuReportCell.swift
//  DJReader
//
//  Created by 季勤强 on 2021/8/5.
//

import UIKit

class ZhihuReportCell: UITableViewCell {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        coverImageView.layer.cornerRadius = 4
    }
    
    func render(with story: Story) {
        coverImageView.setImage(with: story.imageUrl)
        titleLabel.text = story.title
        descLabel.text = story.hint
    }
    
}

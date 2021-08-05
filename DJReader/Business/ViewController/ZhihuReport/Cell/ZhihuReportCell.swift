//
//  ZhihuReportCell.swift
//  DJReader
//
//  Created by 季勤强 on 2021/8/5.
//

import UIKit

class ZhihuReportCell: UITableViewCell {

    @IBOutlet weak var coverImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func render(with story: Story) {
        coverImageView.setImage(with: story.imageUrl)
    }
    
}

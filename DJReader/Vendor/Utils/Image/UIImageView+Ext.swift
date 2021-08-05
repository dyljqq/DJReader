//
//  UIImageView+Ext.swift
//  DJReader
//
//  Created by 季勤强 on 2021/8/5.
//

import UIKit

// TODO: 缓存 + 解码
extension UIImageView {
    func setImage(with urlString: String) {
        guard let _ = URL(string: urlString) else {
            return
        }
        
        // 首先取消之前的图片加载
        ImageDownloadManager.shared.cancel(with: urlString)

        let record = ImageRecord(urlString)
        ImageDownloadManager.shared.startDownload(imageRecord: record) { [weak self] record in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.image = record.image
        }
    }
    
}

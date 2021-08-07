//
//  UIImageView+Ext.swift
//  DJReader
//
//  Created by 季勤强 on 2021/8/5.
//

import UIKit

extension UIImageView {
    func setImage(with urlString: String) {
        guard let _ = URL(string: urlString) else {
            return
        }
        
        // 首先取消之前的图片加载
        ImageDownloadManager.shared.cancel(with: urlString)

        let record = ImageRecord(urlString)
        ImageDownloadManager.shared.startDownload(imageRecord: record) { [weak self] record in
            guard let strongSelf = self, let newImage = record.image else {
                return
            }
            
            if let image = ImageCacheManager.default.value(for: urlString) {
                strongSelf._setImage(image)
                return
            }

            ImageCacheManager.default.store(for: urlString, with: newImage)
            strongSelf._setImage(newImage)
        }
    }
    
    private func _setImage(_ image: UIImage?) {
        guard let data = image?.pngData() else {
            return
        }
        
        ImageDecoder.decode(data: data, to: self.bounds.size, scale: 1) { image in
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    
}

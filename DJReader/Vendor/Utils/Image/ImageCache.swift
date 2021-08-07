//
//  ImageCache.swift
//  DJReader
//
//  Created by 季勤强 on 2021/8/7.
//

import UIKit
import CommonCrypto


enum ImageCacheType {
    case none
    case all
    case disk
    case memory
}

class ImageCacheManager {
    
    static let `default` = ImageCacheManager()
    
    let ioQueue = DispatchQueue(label: "com.dyljqq.ImageCacheManager.io")
    
    func value(for key: String) -> UIImage? {
        if let image = MemoryCache.default.value(for: key) {
            return image
        }
        
        if let image = DiskStorage.default.value(for: key) {
            return image
        }
        
        return nil
    }
    
    func store(for key: String, with image: UIImage) {
        ioQueue.async {
            MemoryCache.default.store(for: key, with: image)
            DiskStorage.default.store(for: key, with: image)
        }
    }
    
}

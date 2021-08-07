//
//  MemoryCache.swift
//  DJReader
//
//  Created by 季勤强 on 2021/8/7.
//

import UIKit

class MemoryCache {
    
    static let `default` = MemoryCache()
    
    let storage = NSCache<NSString, UIImage>()
    
    func store(for key: String, with image: UIImage) {
        let key = NSString(string: key.md5)
        
        guard storage.object(forKey: key) == nil else {
            return
        }
        storage.setObject(image, forKey: key)
    }
    
    func value(for key: String) -> UIImage? {
        let key = NSString(string: key.md5)
        return storage.object(forKey: key)
    }
    
}

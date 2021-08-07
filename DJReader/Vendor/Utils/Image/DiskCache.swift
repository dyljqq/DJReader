//
//  DiskCache.swift
//  DJReader
//
//  Created by 季勤强 on 2021/8/7.
//

import UIKit

class DiskStorage {
    
    static let `default` = DiskStorage()
    
    let cacheDirectories = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
    
    func isCached(for key: String) -> Bool {
        guard let filePath = cacheDirectories.first?.appendingPathComponent(convert(from: key)).path else {
            return false
        }
        return FileManager.default.fileExists(atPath: filePath)
    }
    
    func store(for key: String, with image: UIImage? = nil) {
        guard let data = image?.pngData(), let cacheDirectory = cacheDirectories.first else {
            return
        }
        
        do {
            let filename = convert(from: key)
            try data.write(to: cacheDirectory.appendingPathComponent(filename, isDirectory: false))
        } catch {
            print("error: \(error.localizedDescription)")
        }
        
    }
    
    func value(for key: String) -> UIImage? {
        guard let cacheDirectory = cacheDirectories.first else {
            return nil
        }
        
        let filePath = cacheDirectory.appendingPathComponent(convert(from: key)).path
        guard FileManager.default.fileExists(atPath: filePath) else {
            return nil
        }
        return UIImage(contentsOfFile: filePath)
    }
    
    private func convert(from key: String) -> String {
        return key.md5 + ".png"
    }
    
}

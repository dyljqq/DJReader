//
//  ImageDownloadManager.swift
//  DJReader
//
//  Created by 季勤强 on 2021/8/5.
//

import UIKit

class ImageDownloadManager {
    
    static let shared = ImageDownloadManager()
    
    let pendingOperations: PendingOperations = PendingOperations()
    
    func startDownload(imageRecord: ImageRecord, completionHandler: @escaping (ImageRecord) -> ()) {
        guard pendingOperations.downloadsInProgress[imageRecord.urlString] == nil else {
            return
        }
        
        let downloader = ImageDownloader(imageRecord)
        downloader.completionHandler = { [weak self] record in
            guard let strongSelf = self else {
                return
            }
            
            if downloader.isCancelled {
                return
            }
            
            DispatchQueue.main.async {
                strongSelf.pendingOperations.downloadsInProgress.removeValue(forKey: record.urlString)
                completionHandler(downloader.imageRecord)
            }
        }
        
        pendingOperations.downloadsInProgress[imageRecord.urlString] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
    }
    
    func cancel(with urlString: String) {
        guard let downloader = pendingOperations.downloadsInProgress[urlString] else {
            return
        }
        
        downloader.cancel()
        pendingOperations.downloadsInProgress.removeValue(forKey: urlString)
    }
    
}

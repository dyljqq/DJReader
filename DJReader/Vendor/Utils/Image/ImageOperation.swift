//
//  ImageOperation.swift
//  DJReader
//
//  Created by 季勤强 on 2021/8/5.
//

import UIKit

enum ImageDefaultName {
    case placeholder
    case failed
    
    var image: UIImage? {
        switch self {
        case .placeholder: return UIImage(named: "Placeholder")
        case .failed: return UIImage(named: "Failed")
        }
    }
}

enum ImageRecordState {
    case new
    case download
    case failed
    
    var image: UIImage? {
        switch self {
        case .new: return ImageDefaultName.placeholder.image
        case .failed: return ImageDefaultName.failed.image
        case .download: return nil
        }
    }
}

struct ImageRecord {

    let urlString: String
    
    var state: ImageRecordState = .new
    var image: UIImage? = ImageRecordState.new.image
    
    init(_ urlString: String) {
        self.urlString = urlString
    }
    
    mutating func update(state: ImageRecordState, image: UIImage? = nil) {
        self.state = state
        if let image = image {
            self.image = image
        }
    }
}

class PendingOperations {
    
    lazy var downloadsInProgress: [String: Operation] = [:]
    lazy var downloadQueue: OperationQueue = {
       let queue = OperationQueue()
        queue.name = "com.dyljqq.downloadImage"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
}

class ImageDownloader: Operation {
    
    let imageRecord: ImageRecord
    var completionHandler: ((ImageRecord) -> ())?
    
    init(_ imageRecord: ImageRecord, completionHandler: ((ImageRecord) -> ())? = nil) {
        self.imageRecord = imageRecord
        self.completionHandler = completionHandler
    }
    
    override func main() {
        guard !isCancelled else {
            return
        }
        
        guard let url = URL(string: imageRecord.urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let strongSelf = self else {
                return
            }
            var imageRecord = strongSelf.imageRecord
            if error != nil || strongSelf.isCancelled {
                print("Download Image Error...")
                imageRecord.update(state: .failed)
                strongSelf.completionHandler?(imageRecord)
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("Parse Image error...")
                imageRecord.update(state: .failed)
                strongSelf.completionHandler?(imageRecord)
                return
            }
            
            imageRecord.update(state: .download, image: image)
            strongSelf.completionHandler?(imageRecord)
        }
        task.resume()
    }
    
}

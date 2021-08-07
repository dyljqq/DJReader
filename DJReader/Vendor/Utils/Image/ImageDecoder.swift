//
//  ImageDecoder.swift
//  DJReader
//
//  Created by 季勤强 on 2021/8/7.
//

import UIKit

class ImageDecoder {
    
    static func decode(data: Data, to pointSize: CGSize, scale: CGFloat, completionHandler: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let image = downsampledImage(data: data, to: pointSize, scale: scale)
            DispatchQueue.main.async {
                completionHandler(image)
            }
        }
    }
    
    static func downsampledImage(data: Data, to pointSize: CGSize, scale: CGFloat) -> UIImage? {
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, imageSourceOptions) else {
            return nil
        }
        
        let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
        let downsampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels] as CFDictionary
        guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
            return nil
        }
        return UIImage(cgImage: downsampledImage)
    }
    
    
}

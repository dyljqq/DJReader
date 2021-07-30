//
//  Color.swift
//  DJReader
//
//  Created by 季勤强 on 2021/7/31.
//

import UIKit

struct DJColor {
    
    static let text = UIColorFromRGB(0x43240c)
    static let desc = UIColorFromRGB(0x444444)
    static let background = UIColorFromRGB(0xf5f5f5)
    
}

func UIColorFromRGB(_ rgbValue: UInt, alpha: CGFloat = 1.0) -> UIColor {
  return UIColor(
    red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
    green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
    blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
    alpha: alpha
  )
}

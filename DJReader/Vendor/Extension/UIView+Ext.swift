//
//  UIView+Ext.swift
//  DJReader
//
//  Created by 季勤强 on 2021/7/31.
//

import UIKit

extension UIView {
    
    static var className: String {
        return String(describing: self.classForCoder())
    }
    
    static var nib: UINib {
        return UINib(nibName: self.className, bundle: nil)
    }
    
    static func loadFromNib() -> UIView? {
        return self.nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
}

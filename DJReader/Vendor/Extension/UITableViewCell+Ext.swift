//
//  UITableViewCell+Ext.swift
//  DJReader
//
//  Created by 季勤强 on 2021/7/31.
//

import UIKit

extension UITableViewCell {
    
    class func registerClass(_ tableView: UITableView) {
        tableView.register(classForCoder(), forCellReuseIdentifier: className)
    }
    
    class func registerNib(_ tableView: UITableView) {
        tableView.register(nib, forCellReuseIdentifier: className)
    }
    
}

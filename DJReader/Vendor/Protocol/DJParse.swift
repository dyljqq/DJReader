//
//  DJParse.swift
//  DJReader
//
//  Created by 季勤强 on 2021/7/30.
//

import Foundation

protocol DJParse {
    func parse(data: Data, completionHandler: @escaping ([String: Any]) -> Void)
}

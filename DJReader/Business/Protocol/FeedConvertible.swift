//
//  FeedConvertable.swift
//  DJReader
//
//  Created by 季勤强 on 2021/8/5.
//

import Foundation

protocol FeedConvertible {
    func convert(from dict: [String: Any]) -> Feed?
}

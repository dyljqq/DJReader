//
//  DJParse.swift
//  DJReader
//
//  Created by 季勤强 on 2021/7/30.
//

import Foundation

protocol DJParse {    
    func parse(data: Data, completionHandler: @escaping ([String: Any]) -> Void)
    
    func parse(data: Data) async -> [String: Any]?
}

extension DJParse {
    
    func parse(data: Data, completionHandler: @escaping ([String: Any]) -> Void) {
        guard let dict = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
            return
        }
        completionHandler(dict)
    }
    
    func parse(data: Data) async -> [String: Any]? {
        guard let dict = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
            return nil
        }
        return dict
    }
}

struct DJJSONParse: DJParse {
    
}

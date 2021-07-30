//
//  DJDecoder.swift
//  DJReader
//
//  Created by 季勤强 on 2021/7/30.
//

import Foundation

struct DJDecoder<T: Decodable> {
    
    let decoder = JSONDecoder()
    
    private var data: Data?
    
    init(dict: [String: Any]) {
        do {
            let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            self.init(data: data)
        } catch {
            self.init(data: nil)
        }
    }
    
    init(data: Data?) {
        self.data = data
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func decode() -> T? {
        guard let data = data else {
            return nil
        }

        do {
            let value = try decoder.decode(T.self, from: data)
            return value
        } catch {
            print("parse error: \(error)")
        }
        return nil
    }
    
}

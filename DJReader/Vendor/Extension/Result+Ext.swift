//
//  Re.swift
//  DJReader
//
//  Created by 季勤强 on 2021/12/30.
//

import Foundation

extension Result {
    func decode<T: Decodable>() -> Result<T, DJError> {
        switch self {
        case .success(let v):
            if let dict = v as? [String: Any],
               let value = DJDecoder<T>(dict: dict).decode() {
                return .success(value)
            } else if let v = v as? T {
                return .success(v)
            } else {
                return .failure(.parseError)
            }
        case .failure(let error):
            return .failure(.networkError(error))
        }
    }
    
}

//
//  URLConvertible.swift
//  DJReader
//
//  Created by 季勤强 on 2021/8/5.
//

import Foundation

protocol URLRequestConvertible {
    func asURLRequest() -> URLRequest?
}

extension URLRequestConvertible {
    var urlRequest: URLRequest? { return asURLRequest() }
}

protocol URLConvertible {
    func asURL() throws -> URL
}

extension String: URLConvertible {
    
    func asURL() throws -> URL {
        guard let url = URL(string: self) else {
            throw DJError.invalidURL(self)
        }
        return url
    }
    
}

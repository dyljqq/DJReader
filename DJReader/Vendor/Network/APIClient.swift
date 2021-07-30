//
//  APIClient.swift
//  DJReader
//
//  Created by 季勤强 on 2021/7/30.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
}

class APIClient {
    
    var host: String = ""
    
    static let shared = APIClient()
    
    func get<T: Codable>(source: FeedSource, handler: @escaping (T?) -> Void) {
        self.get(urlString: source.urlString) { dict in
            let value = DJDecoder<T>(dict: dict).decode()
            handler(value)
        }
    }
    
    func get(urlString: String, queryItems: [String: String]? = nil, handler: @escaping ([String: Any]) -> Void) {
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        var validUrl: URL? = url
        if queryItems != nil && !queryItems!.isEmpty {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
            components?.queryItems = queryItems?.compactMap { URLQueryItem(name: $1, value: $0) }
            validUrl = components?.url
        }
        
        guard let validUrl = validUrl else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: validUrl) { (data, response, error) in
            guard error == nil else {
                print("send error: \(error!)")
                return
            }
            
            guard let data = data else {
                return
            }
            
            ZhihuXMLParser().parse(data: data) { dict in
               handler(dict)
            }
        }
        task.resume()
    }
    
}

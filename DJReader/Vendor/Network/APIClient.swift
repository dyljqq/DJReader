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
    
    let queue = DispatchQueue(label: "com.dyljqq.network", attributes: [.concurrent])
    
    static let shared = APIClient()
    
    func get<T: Decodable>(source: FeedSource, handler: @escaping (T?) -> Void) {
        // 兼容非xml数据
        guard source.defaultFeed == nil else {
            handler(source.defaultFeed as? T)
            return
        }
        
        self.get(urlString: source.urlString) { data in
            source.parser?.parse(data: data) { dict in
                let value = DJDecoder<T>(dict: dict).decode()
                DispatchQueue.main.async {
                    handler(value)
                }
             }
        }
    }
    
    func get<T: Decodable>(router: Router, completionHandler: @escaping (T?) -> ()) {
        guard let request = router.asURLRequest() else {
            return
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                print("get error: \(error!)")
                return
            }
            
            guard let data = data else { return }
            let model = DJDecoder<T>(data: data).decode()
            completionHandler(model)
        }
        
        task.resume()
    }
    
    func get(urlString: String, queryItems: [String: String]? = nil, handler: @escaping (Data) -> Void) {
        
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
            
            handler(data)
        }
        task.resume()
    }
    
}

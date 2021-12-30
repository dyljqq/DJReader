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
    
    func get(source: FeedSource) async -> Result<[String: Any], DJError> {
        let r = await get(urlString: source.urlString)
        switch r {
        case .success(let data):
            if let dict = await source.parser?.parse(data: data) {
                return .success(dict)
            } else {
                return .failure(.parseError)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func get<T: Decodable>(router: Router) async -> T? {
        guard let request = router.asURLRequest() else {
            return nil
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            return DJDecoder<T>(data: data).decode()
        } catch {
            print("APIClient get data error: \(error)")
            return nil
        }
    }
    
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
    
    func get(urlString: String, queryItems: [String: String]? = nil) async -> Result<Data, DJError> {
        guard let url = URL(string: urlString) else {
            return .failure(.invalidURL(urlString))
        }
        
        var validUrl: URL? = url
        if queryItems != nil && !queryItems!.isEmpty {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
            components?.queryItems = queryItems?.compactMap { URLQueryItem(name: $1, value: $0) }
            validUrl = components?.url
        }
        
        guard let validUrl = validUrl else {
            return .failure(.invalidURL(urlString))
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: validUrl)
            return .success(data)
        } catch {
            print("APIClient get urlstring error: \(error)")
            return .failure(.networkError(error))
        }
    }
    
}

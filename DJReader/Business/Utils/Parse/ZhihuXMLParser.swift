//
//  ZhihuXMLParser.swift
//  DJReader
//
//  Created by 季勤强 on 2021/7/30.
//

import Foundation

class ZhihuXMLParser: NSObject, DJParse {
    
    var foundCharacters = ""
    var parsingItem = false
    var items: [[String: String]] = []
    var dict: [String: Any] = [:]
    
    var newItemIndex = 0
    var oldItemIndex = 0
    
    var headParseKeys = ["title", "link", "description"]
    var itemParseKeys = ["title", "link", "description", "pubDate"]
    
    var completionHandler: (([String: Any]) -> Void)?
    var continuation: CheckedContinuation<[String: Any]?, Error>?
    
    func parse(data: Data, completionHandler: @escaping ([String: Any]) -> Void) {
        self.completionHandler = completionHandler
        
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }
    
    func parse(data: Data) async -> [String : Any]? {
        do {
            return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[String: Any]?, Error>) in
                self.continuation = continuation
                let parser = XMLParser(data: data)
                parser.delegate = self
                parser.parse()
            }
        } catch {
            print("ZhihuXMLParser parse error: \(error)")
            return nil
        }
    }
    
}

extension ZhihuXMLParser: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if (elementName == "item") {
            parsingItem = true
            newItemIndex = newItemIndex + 1
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.foundCharacters.append(string)
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (!parsingItem && self.headParseKeys.contains(elementName)) {
            dict[elementName] = self.foundCharacters
        }
        
        if parsingItem && self.itemParseKeys.contains(elementName) {
            if newItemIndex > oldItemIndex {
                oldItemIndex = newItemIndex
                self.items.append([elementName: self.foundCharacters])
            } else {
                self.items[self.items.count - 1][elementName] = self.foundCharacters
            }
        }
        
        self.foundCharacters = ""
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        dict["items"] = self.items
        self.continuation?.resume(returning: dict)
    }
    
}

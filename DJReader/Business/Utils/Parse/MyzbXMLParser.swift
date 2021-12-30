//
//  MyzbXMLParser.swift
//  DJReader
//
//  Created by 季勤强 on 2021/8/10.
//

import Foundation

// 摸鱼周报
class MyzbXMLParser: NSObject, DJParse {
    
    var isParseHead = true
    var curElement = ""
    var curEntry: [String: String] = [:]
    
    var head: [String: Any] = [:]
    var items: [[String: String]] = []
    
    var elementNameMapping: [String: String] = [
        "updated": "pubDate",
        "summary": "description",
        "id": "link"
    ]
    
    var completionHandler: (([String: Any]) -> Void)?
    var continuation: CheckedContinuation<[String: Any]?, Error>?
    
    func parse(data: Data, completionHandler: @escaping ([String : Any]) -> Void) {
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
            print("MyzbXMLParser parse error: \(error)")
            return nil
        }
    }
    
}

extension MyzbXMLParser: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

        curElement = elementName
        if elementName == "entry" {
            curEntry = [:]
            isParseHead = false
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .newlines)
        let mappingName = elementNameMapping[curElement] ?? curElement
        curEntry[mappingName] = (curEntry[mappingName] ?? "") + data
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if isParseHead {
            head = curEntry
        } else if elementName == "entry" {
            if let dateString = curEntry["pubDate"] {
                var ds = ""
                let arr = dateString.split(separator: "T")
                if arr.count == 2 {
                    ds = "\(arr[0]) \(arr[1].split(separator: ".")[0])"
                } else {
                    ds = dateString
                }
                curEntry["pubDate"] = ds
            }
            items.append(curEntry)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        head["title"] = "iOS摸鱼周报"
        head["description"] = "iOS摸鱼周报，主要分享大家开发过程遇到的经验教训及一些有用的学习内容。"
        head["items"] = items
        self.continuation?.resume(returning: head)
    }
    
}

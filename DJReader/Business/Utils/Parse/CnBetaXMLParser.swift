//
//  CnBetaXMLParser.swift
//  DJReader
//
//  Created by 季勤强 on 2021/8/4.
//

import Foundation

class CnBetaXMLParser: NSObject, DJParse {
    
    var head: [String: Any] = [:]
    var items: [[String: String]] = []
    
    var isParseHead = true
    var isParseHeadImage = false
    var curElementName: String = ""
    var curItem: [String: String] = [:]
    
    var completionHandler: (([String: Any]) -> Void)?
    
    func parse(data: Data, completionHandler: @escaping ([String: Any]) -> Void) {
        self.completionHandler = completionHandler
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }
}

extension CnBetaXMLParser: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        curElementName = elementName
        if isParseHead && curElementName == "image" {
            isParseHeadImage = true
        } else if curElementName == "item" {
            isParseHead = false
            curItem = [:]
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .newlines)
        if isParseHead {
            if isParseHeadImage {
                if curElementName == "url" {
                    head[curElementName] = (head[curElementName] as? String ?? "") + data
                }
            } else {
                head[curElementName] = (head[curElementName] as? String ?? "") + data
            }
        } else {
            curItem[curElementName] = (curItem[curElementName] ?? "") + data
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "image" {
            isParseHeadImage = false
        } else if elementName == "item" {
            items.append(curItem)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        head["items"] = items
        completionHandler?(head)
    }
    
    
}

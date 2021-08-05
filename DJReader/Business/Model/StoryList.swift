//
//  StoryList.swift
//  DJReader
//
//  Created by 季勤强 on 2021/8/5.
//

import Foundation

struct StoryList: Decodable {
  
  let date: String
  let stories: [Story]
  var topStories: [Story]?
  
}

struct Story: Decodable {
  
  var id: Int
  var title: String
  var type: Int
  var hint: String

  var image: String?
  var images: [String]?
  
  var imageUrl: String {
    return self.image ?? self.images?.first ?? ""
  }
  
}

extension StoryList: FeedConvertible {
    
    func convert(from dict: [String : Any]) -> Feed? {
        guard let storyList = DJDecoder<StoryList>(dict: dict).decode() else {
            return nil
        }
        
        return nil
    }
    
}

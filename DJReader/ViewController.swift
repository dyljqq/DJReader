//
//  ViewController.swift
//  DJReader
//
//  Created by 季勤强 on 2021/7/30.
//

import UIKit

struct User: Codable {
    let name: String
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIClient.shared.get(source:.zhihu, handler: { (feed: Feed?) in
            print(feed?.title)
        })
    }

}


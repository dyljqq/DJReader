//
//  Coordinator.swift
//  DJReader
//
//  Created by 季勤强 on 2021/7/31.
//

import UIKit

protocol Coordinator {
    
    var navigationViewController: UINavigationController { get set }
    
    func start()
    
}

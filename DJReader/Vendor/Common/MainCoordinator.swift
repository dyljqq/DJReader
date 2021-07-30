//
//  MainCoordinator.swift
//  DJReader
//
//  Created by 季勤强 on 2021/7/31.
//

import UIKit

class MainCoordinator: Coordinator {
    
    var navigationViewController: UINavigationController
    
    init(_ navigationViewController: UINavigationController) {
        self.navigationViewController = navigationViewController
    }
    
    func start() {
        guard let vc = self.navigationViewController.topViewController as? MainFeedViewController else {
            return
        }
    }
    
}

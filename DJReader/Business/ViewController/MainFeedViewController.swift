//
//  ViewController.swift
//  DJReader
//
//  Created by 季勤强 on 2021/7/30.
//

import UIKit
import SnapKit

class MainFeedViewController: BaseViewController {

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = DJColor.background
        return tableView
    }()
    
    var mainFeedViewModel = MainFeedViewModel()
    
    var dataSource: [MainFeed] {
        return mainFeedViewModel.dataSource
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
        self.title = "阅读器"
        
        FeedCell.registerNib(tableView)
        
        self.view.addSubview(self.tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mainFeedViewModel.fetchFeeds { [weak self] feeds in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.tableView.reloadData()
            }
        }
    }

}

extension MainFeedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedCell.className, for: indexPath) as! FeedCell
        cell.render(feed: dataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
}

extension MainFeedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let mainFeed = dataSource[indexPath.row]
        self.navigationController?.pushFeedViewController(feed: mainFeed.feed)
    }
    
}


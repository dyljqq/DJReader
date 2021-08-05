//
//  ZhihuReportViewControllerViewController.swift
//  DJReader
//
//  Created by 季勤强 on 2021/8/5.
//

import UIKit
import SnapKit

class ZhihuReportViewController: UIViewController {

    var storyList: StoryList?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = DJColor.background
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
        self.title = "知乎日报"
        self.view.backgroundColor = DJColor.background
        
        register()
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        APIClient.shared.get(router: ZhihuReportRouter.lastNews) { [weak self] (storyList: StoryList?) in
            guard let strongSelf = self else { return }
            
            strongSelf.storyList = storyList
            DispatchQueue.main.async {
                strongSelf.tableView.reloadData()
            }
        }
        
    }
    
    private func register() {
        ZhihuReportCell.registerNib(tableView)
    }

}

extension ZhihuReportViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storyList?.stories.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ZhihuReportCell.className, for: indexPath) as! ZhihuReportCell
        if let story = storyList?.stories[indexPath.row] {
            cell.render(with: story)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
}

extension ZhihuReportViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

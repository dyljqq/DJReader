//
//  ArticleWebViewController.swift
//  DJReader
//
//  Created by 季勤强 on 2021/8/1.
//

import UIKit
import WebKit
import SnapKit
import SafariServices

class ArticleWebViewController: BaseViewController {
    
    let feedItem: FeedItem
    let webView: WKWebView = WKWebView()
    
    init(feedItem: FeedItem) {
        self.feedItem = feedItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = DJColor.background
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.isOpaque = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.isDirectionalLockEnabled = true
        webView.backgroundColor = DJColor.background

        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        self.title = feedItem.title

        let feedString = "\(feedItem.description)<p><a href=\"\(feedItem.link)\">阅读原文</a></p>"
        let articleStrig: String
        if let path = Bundle.main.path(forResource: "css", ofType: "html"),
           let style = try? String(contentsOfFile: path) {
            articleStrig = "\(style)\(feedString)"
        } else {
            articleStrig = feedString
        }

        webView.loadHTMLString(articleStrig, baseURL: nil)
    }
  
}

extension ArticleWebViewController: WKNavigationDelegate {
    
}

extension ArticleWebViewController: WKUIDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url,
           url.absoluteString == feedItem.link {
            let vc = SFSafariViewController(url: url)
            self.present(vc, animated: true)
        }
        decisionHandler(.allow)
    }
}

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
    lazy var webView: WKWebView = {
       let webView = WKWebView(frame: screenBounds, configuration: webConfig)
        return webView
    }()
    
    // nice job!!!!
    let photoJS = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta); var imgs = document.getElementsByTagName('img');for (var i in imgs){imgs[i].style.maxWidth='100%';imgs[i].style.height='auto';}"
    
    lazy var userScript: WKUserScript = {
        let us = WKUserScript(source: photoJS, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        return us
    }()
    
    lazy var userContentController: WKUserContentController = {
       let userContentController = WKUserContentController()
        userContentController.addUserScript(userScript)
        return userContentController
    }()
    
    lazy var webConfig: WKWebViewConfiguration = {
      let config = WKWebViewConfiguration()
        config.userContentController = userContentController
        return config
    }()
    
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

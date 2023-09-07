//
//  BlogReviewDetailViewController.swift
//  BG_iOS
//
//  Created by 우진 on 2023/09/07.
//

import UIKit
import WebKit

class BlogReviewDetailViewController: UIViewController, WKUIDelegate {
    
    var blogLink: String?

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.uiDelegate = self // a link target=_blank 동작하도록
        loadWebPage(blogLink ?? "https://naver.com")
        navigationController?.navigationItem.backButtonTitle = ""
        
    }
    
    private func loadWebPage(_ url: String) {
        guard let myUrl = URL(string: url) else {
            return
        }
        let request = URLRequest(url: myUrl)
        DispatchQueue.main.async {
            self.webView.load(request)
        }
    }
    
    // a link target=_blank 동작하도록
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }

}

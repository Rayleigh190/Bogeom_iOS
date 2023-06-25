//
//  MapViewController.swift
//  BG_iOS
//
//  Created by 우진 on 2023/06/25.
//

import UIKit
import WebKit

class MapViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = Bundle.main.MAP_URL!
        loadWebPage(url)
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    private func loadWebPage(_ url: String) {
//        loadHTMLString(<#T##String#>, baseURL: <#T##URL?#>)
        guard let myUrl = URL(string: url) else {
            return
        }
        let request = URLRequest(url: myUrl)
        webView.load(request)
        webView.reload()
    }


}

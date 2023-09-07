//
//  SearchResultViewController.swift
//  BG_iOS
//
//  Created by 우진 on 2023/05/26.
//

import UIKit
import Kingfisher
import WebKit
import Alamofire

class SearchResultViewController: UIViewController, WKUIDelegate {
    
    var reviewData: BlogReviewAPIResponse?
    
    
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var floatingStackView: UIStackView!
    @IBOutlet weak var floatingButton: UIButton!
    @IBOutlet weak var naverButton: UIButton!
    @IBOutlet weak var enuriButton: UIButton!
    @IBOutlet weak var danawaButton: UIButton!
    @IBOutlet weak var blogReviewButton: UIButton!
    
    lazy var floatingDimView: UIView = {
        let view = UIView(frame: self.view.frame)
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.alpha = 0
        view.isHidden = true

        self.view.insertSubview(view, belowSubview: self.floatingStackView)

        return view
    }()
    
    var isShowFloating: Bool = false

    lazy var buttons: [UIButton] = [self.naverButton, self.enuriButton  , self.danawaButton, self.blogReviewButton]
    
    var itemName: String?
    var enuri_link: String?
    var danawa_link: String?
    var naver_link: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.uiDelegate = self // a link target=_blank 동작하도록
        updateUI()
        
        let defaultShop: String = UserDefaults.standard.string(forKey: "defaultSearchShop")!
        if defaultShop == "naver" {
            loadWebPage(naver_link ?? "https://naver.com")
        } else if defaultShop == "enuri" {
            loadWebPage(enuri_link ?? "https://naver.com")
        } else {
            loadWebPage(danawa_link ?? "https://naver.com")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.backgroundColor = .clear
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
    
    func updateUI() {
        let chevronLeft = UIImage(systemName: "chevron.left")
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: chevronLeft, style: .plain, target: self, action: #selector(SearchResultViewController.tapToBack))
        self.navigationController?.navigationBar.tintColor = .black
        
    }
    
    @objc func tapToBack() {
        if let captureViewController = navigationController?.viewControllers.first(where: { $0 is CaptureViewController }) {
            navigationController?.popToViewController(captureViewController, animated: true)
        } else {
            let viewController = navigationController?.viewControllers.first(where: { $0 is ViewController })
            navigationController?.popToViewController(viewController!, animated: true)
        }
    }
    

}

extension SearchResultViewController {
    
    func toggleFloatingButton() {
        if isShowFloating {
            buttons.reversed().forEach { button in
                UIView.animate(withDuration: 0.3) {
                    button.isHidden = true
                    self.view.layoutIfNeeded()
                }
            }

            UIView.animate(withDuration: 0.5, animations: {
                self.floatingDimView.alpha = 0
            }) { (_) in
                self.floatingDimView.isHidden = true
            }
        } else {

            self.floatingDimView.isHidden = false

            UIView.animate(withDuration: 0.5) {
                self.floatingDimView.alpha = 1
            }

            buttons.forEach { [weak self] button in
                button.isHidden = false
                button.alpha = 0

                UIView.animate(withDuration: 0.3) {
                    button.alpha = 1
                    self?.view.layoutIfNeeded()
                }
            }
        }

        isShowFloating = !isShowFloating

//        let image = isShowFloating ?  UIImage(systemName: "xmark.circle.fill") : UIImage(systemName: "plus.circle.fill")
        let roatation = isShowFloating ? CGAffineTransform(rotationAngle: .pi - (.pi / 4)) : CGAffineTransform.identity

        UIView.animate(withDuration: 0.3) {
//            self.floatingButton.setImage(image, for: .normal)
            self.floatingButton.transform = roatation
        }
    }
    
    @IBAction func floatingButtonAction(_ sender: UIButton) {
        toggleFloatingButton()
    }
    
    @IBAction func naverButtonAction(_ sender: UIButton) {
        loadWebPage(naver_link ?? "https://naver.com")
        toggleFloatingButton()
    }
    
    @IBAction func enuriButtonAction(_ sender: UIButton) {
        loadWebPage(enuri_link ?? "https://enuri.com")
        toggleFloatingButton()
    }
    
    @IBAction func danawqButtonAction(_ sender: UIButton) {
        loadWebPage(danawa_link ?? "https://danawa.com")
        toggleFloatingButton()
    }
    
    @IBAction func blogReviewButtonAction(_ sender: UIButton) {
        blogReviewSearch(search: itemName!)
//        self.performSegue(withIdentifier: "showSearchBlogReview", sender: self)
//        toggleFloatingButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSearchBlogReview" {
            let vc = segue.destination as? BlogReviewViewController
            vc?.itemName = itemName
            vc?.reviewData = reviewData
        }
    }
    
    func blogReviewSearch(search: String) {
        
        let url = Bundle.main.getSecret(name: "Blog_Review_SEARCH_API_URL")
        
        let parameters: Parameters = ["search": search]
        
        AF.request(url, method: .get, parameters: parameters).responseDecodable(of: BlogReviewAPIResponse.self)
        { response in
            switch response.result {
            case .success(let successData):
                print("성공")
//                print(successData)
                self.reviewData = successData
                self.performSegue(withIdentifier: "showSearchBlogReview", sender: self)
            case .failure(let error):
                print("실패")
                print(response)
                print(false, error.localizedDescription)
            }
        }
    }
    
}

//
//  ViewController.swift
//  BG_iOS
//
//  Created by 우진 on 2023/05/19.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    var itemName: String?
    var enuri_link: String?
    var danawq_link: String?
    var naver_link: String?

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var hotItemStackView: UIStackView!
    @IBOutlet weak var adImageView: UIImageView!
    @IBOutlet weak var adBottomSectionView: UIView!
    @IBOutlet weak var adButton: UIButton!
    @IBOutlet weak var adStackView: UIStackView!
    @IBOutlet weak var adParentStackView: UIStackView!
    @IBOutlet weak var shopSelectStackView: UIStackView!
    
    @IBOutlet weak var naverSelectButton: UIButton!
    @IBOutlet weak var enuriSelectButton: UIButton!
    @IBOutlet weak var danawaSelectButton: UIButton!
    
    var hotItemNameList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        searchBar.searchTextField.backgroundColor = UIColor.white
        setupViews()
        setupGestureRecognizers()
        
        // 앱 설치 후 한 번만 실행
        if UserDefaults.standard.bool(forKey: "launchedBefore") == false {
            UserDefaults.standard.set("naver", forKey: "defaultSearchShop")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true) // 뷰 컨트롤러가 나타날 때 숨기기
        changeStatusBarBgColor(bgColor: UIColor(named: "BaseYellow"))
        getHotItemInfo()
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true) // 뷰 컨트롤러가 사라질 때 나타내기
        changeStatusBarBgColor(bgColor: UIColor.white)
    }
    
    

}

private extension ViewController {
    
    func updateUI() {
        // 기본 검색 사이트 설정에 따른 UI 업데이트
        let defaultShop: String = UserDefaults.standard.string(forKey: "defaultSearchShop")!
        if defaultShop == "naver" {
            let button = shopSelectStackView.arrangedSubviews[0] as? UIButton
            button?.isSelected = true
            button?.backgroundColor = UIColor.init(hexCode: "03CF5D")
        } else if defaultShop == "enuri" {
            let button = shopSelectStackView.arrangedSubviews[1] as? UIButton
            button?.isSelected = true
            button?.backgroundColor = UIColor.init(hexCode: "0092FF")
        } else {
            let button = shopSelectStackView.arrangedSubviews[2] as? UIButton
            button?.isSelected = true
            button?.backgroundColor = UIColor.init(hexCode: "68C91C")
        }
        
        naverSelectButton.layer.borderWidth = 3
        naverSelectButton.layer.borderColor = UIColor.init(hexCode: "03CF5D").cgColor
        naverSelectButton.layer.cornerRadius = naverSelectButton.frame.height / 2
        naverSelectButton.layer.masksToBounds = true
        
        enuriSelectButton.layer.borderWidth = 3
        enuriSelectButton.layer.borderColor = UIColor.init(hexCode: "0092FF").cgColor
        enuriSelectButton.layer.cornerRadius = enuriSelectButton.frame.height / 2
        enuriSelectButton.layer.masksToBounds = true
        
        danawaSelectButton.layer.borderWidth = 3
        danawaSelectButton.layer.borderColor = UIColor.init(hexCode: "68C91C").cgColor
        danawaSelectButton.layer.cornerRadius = danawaSelectButton.frame.height / 2
        danawaSelectButton.layer.masksToBounds = true
        
    }
    
    func setupViews() {
        hotItemStackView.backgroundColor = .systemBackground
        hotItemStackView.layer.shadowColor = UIColor.black.cgColor
        hotItemStackView.layer.shadowOpacity = 0.2
        hotItemStackView.layer.shadowOffset = CGSize(width: 0, height: 5)
        hotItemStackView.layer.shadowRadius = 5
        hotItemStackView.layer.masksToBounds = false
        hotItemStackView.layer.cornerRadius = 15
        
        adStackView.backgroundColor = .systemBackground
        adStackView.layer.masksToBounds = true
        adStackView.layer.cornerRadius = 15
        
        adParentStackView.layer.shadowColor = UIColor.black.cgColor
        adParentStackView.layer.shadowOpacity = 0.2
        adParentStackView.layer.shadowOffset = CGSize(width: 0, height: 5)
        adParentStackView.layer.shadowRadius = 5
        adParentStackView.layer.masksToBounds = false
        
        adButton.layer.cornerRadius = 20
        
    }
    
    func hotItemStackUpdate() {
        var count = 0
        for case let myStackView as UIStackView in hotItemStackView.arrangedSubviews {
            if myStackView != hotItemStackView.arrangedSubviews.last {
                if let label = myStackView.subviews[1] as? UILabel {
                    // Update the label text
//                    print(hotItemNameList)
                    label.text = hotItemNameList[count]
                    count += 1
                }
            }
        }
        
    }
    
    func setupGestureRecognizers() {
        for case let myStackView as UIStackView in hotItemStackView.arrangedSubviews {
            if let label = myStackView.subviews.first(where: { $0 is UILabel }) as? UILabel {
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
                label.isUserInteractionEnabled = true
                label.addGestureRecognizer(tapGestureRecognizer)
            }
        }
    }

    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        if let label = sender.view as? UILabel {
            textSearch(search: label.text ?? "")
        }
    }
    
    @IBAction func selectShopBtnAction(_ sender: UIButton) {
        for view in shopSelectStackView.arrangedSubviews {
            if let btn = view as? UIButton {
                if btn == sender {
                    // If the current button is the button that called this function
                    btn.isSelected = true
//                    btn.backgroundColor = UIColor.blue
                    
                    let idx = shopSelectStackView.arrangedSubviews.firstIndex(of: btn)
                    if idx == 0 {
                        UserDefaults.standard.set("naver", forKey: "defaultSearchShop")
                        btn.backgroundColor = UIColor.init(hexCode: "03CF5D")
                    } else if idx == 1 {
                        UserDefaults.standard.set("enuri", forKey: "defaultSearchShop")
                        btn.backgroundColor = UIColor.init(hexCode: "0092FF")
                    } else {
                        UserDefaults.standard.set("danawa", forKey: "defaultSearchShop")
                        btn.backgroundColor = UIColor.init(hexCode: "68C91C")
                    }
                } else {
                    // If it is not the button that called this function
                    btn.isSelected = false
                    btn.backgroundColor = UIColor.systemBackground
                }
            }
        }
    }
    
    func getHotItemInfo() {
        let url = Bundle.main.getSecret(name: "HOT_ITEM_API_URL")
        
        AF.request(url, method: .get).responseDecodable(of: HotItemAPIResponse.self)
        { response in
            switch response.result {
            case .success(let successData):
                print("실시간 인기 검색 상품 성공")
//                print(successData)
                self.hotItemNameList = []
                for item in successData.response.items {
                    self.hotItemNameList.append(item.itemName)
                }
//                print(self.hotItemNameList)
                self.hotItemStackUpdate()
            case .failure(let error):
                print("실시간 인기 검색 상품 실패")
                print(response)
                print(false, error.localizedDescription)
            }
        }
    }
    
    func textSearch(search: String) {
        
        let url = Bundle.main.getSecret(name: "TEXT_SEARCH_API_URL")
        
        let parameters: Parameters = ["search": search]
        
        AF.request(url, method: .get, parameters: parameters).responseDecodable(of: SearchAPIResponse.self)
        { response in
            switch response.result {
            case .success(let successData):
                print("성공")
//                print(successData)
                self.itemName = successData.response.item.itemName
                self.enuri_link = successData.response.shop.enuri?.list
                self.danawq_link = successData.response.shop.danawa?.list
                self.naver_link = successData.response.shop.naver?.list
                self.performSegue(withIdentifier: "showTextSearchResult", sender: self)
            case .failure(let error):
                print("실패")
                print(response)
                print(false, error.localizedDescription)
            }
        }
        
    }
    
    func changeStatusBarBgColor(bgColor: UIColor?) {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.first
            let statusBarManager = window?.windowScene?.statusBarManager
    
            let statusBarView = UIView(frame: statusBarManager?.statusBarFrame ?? .zero)
            statusBarView.backgroundColor = bgColor
    
            window?.addSubview(statusBarView)
        } else {
            let statusBarView = UIApplication.shared.value(forKey: "statusBar") as? UIView
            statusBarView?.backgroundColor = bgColor
        }
    }
    
    @IBAction func goAdPage(_ sender: UIButton) {
        Utils.openExternalLink(urlStr: "https://www.nike.com/kr/t/%EC%97%90%EC%96%B4-%ED%8F%AC%EC%8A%A4-1-07-%EB%82%A8%EC%84%B1-%EC%8B%A0%EB%B0%9C-TttlGpDb/CW2288-111")
    }
    
}

extension ViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTextSearchResult" {
            let vc = segue.destination as? SearchResultViewController
            vc?.itemName = itemName
            vc?.enuri_link = enuri_link
            vc?.danawa_link = danawq_link
            vc?.naver_link = naver_link
        }
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        // 검색어가 있는지
        guard let searchTerm = searchBar.text, searchTerm.isEmpty == false else { return }
        textSearch(search: searchTerm)
    }
}

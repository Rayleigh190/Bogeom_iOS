//
//  ViewController.swift
//  BG_iOS
//
//  Created by 우진 on 2023/05/19.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var hotItemStackView: UIStackView!
    
    var hotItemNameList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        searchBar.searchTextField.backgroundColor = UIColor.white
        getHotItemInfo()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true) // 뷰 컨트롤러가 나타날 때 숨기기
        changeStatusBarBgColor(bgColor: UIColor(named: "BaseYellow"))
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true) // 뷰 컨트롤러가 사라질 때 나타내기
        changeStatusBarBgColor(bgColor: UIColor.white)
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

private extension ViewController {
    
    func setupViews() {
        
        hotItemStackView.backgroundColor = .systemBackground
        hotItemStackView.layer.shadowColor = UIColor.black.cgColor
        hotItemStackView.layer.shadowOpacity = 0.2
        hotItemStackView.layer.shadowOffset = CGSize(width: 0, height: 5)
        hotItemStackView.layer.shadowRadius = 5
        hotItemStackView.layer.masksToBounds = false
        hotItemStackView.layer.cornerRadius = 15
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
    
    func getHotItemInfo() {
        let url = Bundle.main.getSecret(name: "HOT_ITEM_API_URL")
        
        AF.request(url, method: .get).responseDecodable(of: HotItemAPIResponse.self)
        { response in
            switch response.result {
            case .success(let successData):
                print("성공")
                print(successData)
                for item in successData.response.items {
                    self.hotItemNameList.append(item.itemName)
                }
                print(self.hotItemNameList)
                self.hotItemStackUpdate()
            case .failure(let error):
                print("실패")
                print(response)
                print(false, error.localizedDescription)
            }
        }
    }
}

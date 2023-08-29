//
//  ViewController.swift
//  BG_iOS
//
//  Created by 우진 on 2023/05/19.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.searchTextField.backgroundColor = UIColor.white
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


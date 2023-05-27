//
//  SearchResultViewController.swift
//  BG_iOS
//
//  Created by 우진 on 2023/05/26.
//

import UIKit

class SearchResultViewController: UIViewController {
    
    
    @IBOutlet weak var itemID: UILabel!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    
    var item_id: Int? = 0
    var item_name: String? = "결과 없음"
    var item_price: Int? = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        // Do any additional setup after loading the view.
    }
    
    func updateUI() {
        let chevronLeft = UIImage(systemName: "chevron.left")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: chevronLeft, style: .plain, target: self, action: #selector(SearchResultViewController.tapToBack))
        if let item_id = self.item_id, let item_name = self.item_name, let item_price = self.item_price {
            itemID.text = "\(item_id)"
            itemName.text = item_name
            itemPrice.text = "\(item_price)"
        }
    }
    
    @objc func tapToBack() {
        let controller = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 3]
        self.navigationController?.popToViewController(controller!, animated: true)
    }
    

}

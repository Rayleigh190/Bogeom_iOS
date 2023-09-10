//
//  ItemSelectViewController.swift
//  BG_iOS
//
//  Created by 우진 on 2023/09/08.
//

import UIKit
import Alamofire

class ItemSelectViewController: UIViewController {
    
    var itemSelectVCDelegate: ItemSelectVCDelegate?
    
    var itemData: ItemAPIResponse?
    var shopData: ShopAPIResponse?
    var userLat: Double?
    var userLon: Double?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        print(itemData!)
        print(userLon!, userLat!)
    }

}

extension ItemSelectViewController {
    
    func shopSearch(id: Int, lat: Double, lon: Double, completion: @escaping (Bool) -> Void) {
        
        let url = Bundle.main.getSecret(name: "SHOP_SEARCH_API_URL")
        
        let parameters: Parameters = ["id": id, "lat": lat, "lon": lon]
        
        AF.request(url, method: .get, parameters: parameters).responseDecodable(of: ShopAPIResponse.self)
        { response in
            switch response.result {
            case .success(let successData):
                print("성공")
//                print(successData)
                self.shopData = successData
                completion(true)
            case .failure(let error):
                print("실패")
                print(response)
                print(false, error.localizedDescription)
                completion(false)
            }
        }
        
    }
    
}

extension ItemSelectViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (itemData?.response.items.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemSelectCell", for: indexPath) as? ItemSelectCell else { return UITableViewCell() }
        
        cell.itemNameLabel.text = itemData?.response.items[indexPath.row].itemName

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemID = itemData?.response.items[indexPath.row].id
        shopSearch(id: itemID!, lat: userLat!, lon: userLon!) { success in
            if success {
                if self.shopData?.response.markets.count == 0 {
                    print("주변에 해당 상품 없음. 알림 띄우기")
                }
                self.itemSelectVCDelegate?.dismissItemSelectVC(shopData: self.shopData!, itemID: itemID!)
                self.dismiss(animated: true)
            } else {
                print("fail")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
}

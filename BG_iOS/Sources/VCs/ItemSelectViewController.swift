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
        
        let baseUrl = Bundle.main.getSecret(name: "BASE_API_URL")
        if let imageUrl = itemData?.response.items[indexPath.row].itemImg {
            cell.itemImageView.kf.setImage(with: URL(string: baseUrl+imageUrl))
        } else {
            cell.itemImageView.kf.setImage(with: URL(string: "https://icon-library.com/images/no-image-icon/no-image-icon-0.jpg"))
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemID = itemData?.response.items[indexPath.row].id
        shopSearch(id: itemID!, lat: userLat!, lon: userLon!) { success in
            if success {
                if self.shopData?.response.markets.count == 0 {
                    print("주변에 해당 상품 없음. 알림 띄우기")
                    // 1. 알람 인스턴스 생성
                    let alert = UIAlertController(title:"알림", message: "현재 지역에 해당 상품이 등록있지 않습니다.\n전남대 부근으로 이동하겠습니까?", preferredStyle: .alert)

                    // 2. 액션 생성
                    let okAction = UIAlertAction(title: "확인", style: .default) { _ in
                        // 지도 카메라를 전남대 근처로 이동
                        self.itemSelectVCDelegate?.dismissItemSelectVC(shopData: self.shopData!, itemID: itemID!, isConfirm: true)
                        self.dismiss(animated: true)
                    }
                    let cancleAction = UIAlertAction(title: "취소", style: .destructive) { _ in
                        // 창 내림
                        self.dismiss(animated: true)
                    }

                    // 3. 알람에 액션 추가
                    alert.addAction(cancleAction)
                    alert.addAction(okAction)

                    // 4. 화면에 표현
                    self.present(alert, animated: true)
                } else {
                    self.itemSelectVCDelegate?.dismissItemSelectVC(shopData: self.shopData!, itemID: itemID!, isConfirm: false)
                    self.dismiss(animated: true)
                }
            } else {
                print("fail")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
}

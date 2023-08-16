//
//  SearchViewController.swift
//  BG_iOS
//
//  Created by 우진 on 2023/05/20.
//

import UIKit
import Alamofire


class SearchViewController: UIViewController {
    
    var item_id: Int? = 0
    var item_name: String? = "결과 없음"
    var item_price: Int? = 0
    
    @IBOutlet weak var imgView: UIImageView!
    
    var cropImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        uploadPhoto(image: cropImage!)
    }
    
    
    func updateUI() {
        imgView.image = cropImage
        imgView.transform = imgView.transform.rotated(by: .pi/2)
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    
    func uploadPhoto(image: UIImage) {
        guard let imgData = image.jpegData(compressionQuality: 1) else { print("사진오류"); return}
        // [http 요청 주소 지정]
        let url = Bundle.main.MAIN_API_URL!
        // [http 요청 헤더 지정]
        let header : HTTPHeaders = [
            "Content-Type" : "multipart/form-data"
        ]
        AF.upload(multipartFormData: { multipartData in
            /** 서버로 전송할 데이터 */
            multipartData.append(imgData, withName: "image", fileName: "temp.jpeg", mimeType: "image/jpeg")
        }, to: url, headers: header).responseDecodable(of: itemModel.self){ response in
            switch response.result {
            case .success(let successData):
                print("성공")
                print(successData)
//                print(successData.item_id!)
//                print(successData.item_name!)
//                print(successData.item_price!)
//                self.item_id = successData.item_id!
//                self.item_name = successData.item_name!
//                self.item_price = successData.item_price!
                self.performSegue(withIdentifier: "showSearchResult", sender: successData)
            case .failure(let error):
                print("실패")
                print(response)
                print(false, error.localizedDescription)
            }
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSearchResult" {
            let vc = segue.destination as? SearchResultViewController
            if let item = sender as? itemModel{
                vc?.itemInfo = item.itemInfo
                vc?.itemReview = item.itemReview
                vc?.itemOnlinePrice = item.itemOnlinePrice
            }
        }
    }
    
}

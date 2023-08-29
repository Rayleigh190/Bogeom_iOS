//
//  SearchViewController.swift
//  BG_iOS
//
//  Created by 우진 on 2023/05/20.
//

import UIKit
import Alamofire


class SearchViewController: UIViewController {
    
    var itemName: String?
    var enuri_link: String?
    var danawq_link: String?
    var naver_link: String?
    
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
        let url = Bundle.main.getSecret(name: "CAMERA_SEARCH_API_URL")
        // [http 요청 헤더 지정]
        let header : HTTPHeaders = ["Content-Type" : "multipart/form-data"]
        
        AF.upload(multipartFormData: { multipartData in
            /** 서버로 전송할 데이터 */
            multipartData.append(imgData, withName: "image", fileName: "temp.jpeg", mimeType: "image/jpeg")
            // Append latitude and longitude
            let latData = Data("\(37.2505405)".utf8) // Convert latitude to data
            multipartData.append(latData, withName: "lat")
            
            let lonData = Data("\(127.0372674)".utf8) // Convert longitude to data
            multipartData.append(lonData, withName: "lon")
        }, to: url, headers: header).responseDecodable(of: SearchAPIResponse.self)
        { response in
            switch response.result {
            case .success(let successData):
                print("성공")
                self.itemName = successData.response.item.itemName
                self.enuri_link = successData.response.shop.enuri?.list
                self.danawq_link = successData.response.shop.danawa?.list
                self.naver_link = successData.response.shop.naver?.list
                self.performSegue(withIdentifier: "showSearchResult", sender: self)
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
            vc?.itemName = itemName
            vc?.enuri_link = enuri_link
            vc?.danawa_link = danawq_link
            vc?.naver_link = naver_link
        }
    }
    
}

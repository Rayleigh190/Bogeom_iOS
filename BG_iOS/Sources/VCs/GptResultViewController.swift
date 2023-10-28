//
//  GptResultViewController.swift
//  BG_iOS
//
//  Created by 우진 on 2023/09/10.
//

import UIKit
import Alamofire

class GptResultViewController: UIViewController {
    
    var link = "https://blog.naver.com/sosohi_/223080612054"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var resultLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        chatGptReq(link: link)
    }
    

    func chatGptReq(link: String) {
        
        let url = Bundle.main.getSecret(name: "GPT_API_URL")
        
        let jsonData: [String: String] = [
            "link": link
        ]
        
        AF.request(url, method: .post, parameters: jsonData, encoder: JSONParameterEncoder.default).responseDecodable(of: GptResponse.self) { response in
            switch response.result {
            case .success(let successData):
                print("성공")
                print(successData)
                self.titleLabel.text = "블로그 리뷰가 요약 되었습니다!"
                self.subTitleLabel.text = ""
                self.activityIndicator.stopAnimating()
                self.resultLable.text = successData.result
                self.resultLable.isHidden = false
            case .failure(let error):
                print("실패")
                print(response)
                print(false, error.localizedDescription)
                self.titleLabel.text = "블로그 리뷰를 요약하는데"
                self.subTitleLabel.text = "오류가 발생했어요!"
                self.activityIndicator.stopAnimating()
                self.resultLable.text = "요약할 수 없는 블로그입니다. 현재는 네이버 블로그만 요약 기능을 제공합니다."
                self.resultLable.isHidden = false
            }
        }
    }
}

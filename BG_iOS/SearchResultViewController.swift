//
//  SearchResultViewController.swift
//  BG_iOS
//
//  Created by 우진 on 2023/05/26.
//

import UIKit
import Kingfisher

class SearchResultViewController: UIViewController {
    
    var reviewNumList:[Int] = []
    let reviewNameList:[String] = ["향기", "청결정도", "자극", "견고", "사용감", "매운", "양", "맛", "당도"]
    let reviewScentList:[String] = ["향기가 나빠요..", "향기가 별로예요..", "향기가 적당해요.", "향기가 좋아요!", "향기가 매우 좋아요!"]
    let reviewCleanLIst:[String] = ["매우 잘 안 닦여요..", "잘 안 닦여요..", "적당히 닦여요.", "깨끗이 닦여요!", "매우 깨끗이 닦여요!"]
    let reviewStimulationList:[String] = ["자극이 매우 적어요!", "자극이 적어요!", "적당한 자극이예요.", "자극이 강해요..", "자극이 매우 강해요.."]
    let reviewSolidityList:[String] = ["매우 안 견고해요..", "안 견고해요..", "조금 견고해요.", "적당히 견고해요!", "매우 견고해요!"]
    let reviewAfterfeelList:[String] = ["사용감이 매우 안 좋아요..", "사용감이 안 좋아요..", "사용감이 적당해요.", "사용감이 좋아요!", "사용감이 매우 좋아요!"]
    let reviewSpicy:[String] = ["매우 안 매워요..", "안 매워요..", "조금 매워요.", "적당히 매워요!", "매우 매워요!"]
    let reviewAmount:[String] = ["양이 매우 적어요..", "양이 적어요..", "양이 적당해요.", "양이 많아요!", "양이 매우 많아요!"]
    let reviewTaste:[String] = ["맛이 매우 별로예요..", "맛이 별로예요..", "적당한 맛이에요.", "조금 맛있어요!", "매우 맛있어요!"]
    let reviewSugar:[String] = ["당도가 매우 낮아요..", "당도가 낮아요..", "당도가 적당해요.", "당도가 높아요!", "당도가 매우 높아요!"]
    lazy var reviewInfoList:[[String]] = [self.reviewScentList, self.reviewCleanLIst, self.reviewStimulationList, self.reviewSolidityList, self.reviewAfterfeelList , self.reviewSpicy ,self.reviewAmount ,self.reviewTaste ,self.reviewSugar]
    
    @IBOutlet weak var itemImg: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var marketLogo1: UIImageView!
    @IBOutlet weak var marketLogo2: UIImageView!
    @IBOutlet weak var marketLogo3: UIImageView!
    @IBOutlet weak var marketPrice1: UILabel!
    @IBOutlet weak var marketPrice2: UILabel!
    @IBOutlet weak var marketPrice3: UILabel!
    @IBOutlet weak var deliverFee1: UILabel!
    @IBOutlet weak var deliverFee2: UILabel!
    @IBOutlet weak var deliverFee3: UILabel!
    
    @IBOutlet weak var reviewStack: UIStackView!
    
    @IBOutlet weak var itemDetailImg: UIImageView!
    //    var item_id: Int? = 0
//    var item_name: String? = "결과 없음"
//    var item_price: Int? = 0
    
    var itemInfo: itemInfo?
    var itemReview: itemReview?
    var itemOnlinePrice: [itemOnlinePrice]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        
//        for v in reviewStack.arrangedSubviews[1...] {
//            for s in v.subviews  {
//                if let labelView = s as? UILabel {
//                    labelView.text = "1"
//                }
//            }
//        }
    }
    
    func updateUI() {
        let chevronLeft = UIImage(systemName: "chevron.left")
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: chevronLeft, style: .plain, target: self, action: #selector(SearchResultViewController.tapToBack))
        
        if let itemInfo = self.itemInfo, let _ = self.itemReview, let _ = self.itemOnlinePrice {
            itemImg.kf.setImage(with: URL(string: itemInfo.itemImg))
            itemDetailImg.kf.setImage(with: URL(string: itemInfo.detailImg))
            itemName.text = itemInfo.itemName
            marketLogo1.kf.setImage(with: URL(string: (itemOnlinePrice?[0].marketLogo)!))
            marketLogo2.kf.setImage(with: URL(string: (itemOnlinePrice?[1].marketLogo)!))
            marketLogo3.kf.setImage(with: URL(string: (itemOnlinePrice?[2].marketLogo)!))
            marketPrice1.text = "\(itemOnlinePrice![0].marketPrice)원"
            marketPrice2.text = "\(itemOnlinePrice![1].marketPrice)원"
            marketPrice3.text = "\(itemOnlinePrice![2].marketPrice)원"
            deliverFee1.text = "\(itemOnlinePrice![0].deliverFee)원"
            deliverFee2.text = "\(itemOnlinePrice![1].deliverFee)원"
            deliverFee3.text = "\(itemOnlinePrice![2].deliverFee)원"
            self.reviewNumList.append(itemReview!.totalScent)
            self.reviewNumList.append(itemReview!.totalClean)
            self.reviewNumList.append(itemReview!.totalStimulation)
            self.reviewNumList.append(itemReview!.totalSolidity)
            self.reviewNumList.append(itemReview!.totalAfterfeel)
            self.reviewNumList.append(itemReview!.totalSpicy)
            self.reviewNumList.append(itemReview!.totalAmount)
            self.reviewNumList.append(itemReview!.totalTaste)
            self.reviewNumList.append(itemReview!.totalSugar)
            
            for (i, v) in reviewStack.arrangedSubviews[1...].enumerated() {
                for (j, s) in v.subviews.enumerated()  {
                    if (reviewNumList[i]==0) {
                        v.removeFromSuperview() // v로?
                    } else {
                        if (j==0){
                            if let labelView = s as? UILabel {
                                labelView.text = reviewNameList[i]
                            }
                        }
                        if (j==1){
                            for (s_index, star) in s.subviews.enumerated() {
                                if (s_index < reviewNumList[i]) {
                                    if let labelView = star as? UIImageView {
                                        labelView.image = UIImage(systemName: "star.fill")
                                        
                                    }
                                }
                            }
                        }
                        if (j==2) {
                            print(s)
                            if let labelView = s as? UILabel {
                                labelView.text = reviewInfoList[i][reviewNumList[i]-1]
                                print(labelView.text!)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func tapToBack() {
        let controller = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 3]
        self.navigationController?.popToViewController(controller!, animated: true)
    }
    

}



//
//  Model.swift
//  BG_iOS
//
//  Created by 우진 on 2023/05/27.
//

import Foundation

struct itemModel: Codable{
    
    let itemInfo: itemInfo
    let itemReview: itemReview
    let itemOnlinePrice: [itemOnlinePrice]
    
    enum CodingKeys: String, CodingKey {
        case itemInfo
        case itemReview
        case itemOnlinePrice
    }
}
struct itemInfo: Codable {
    let itemId: Int, itemName: String, itemImg: String, detailImg: String
}
struct itemReview: Codable {
    var reviewRate: Int, totalScent:Int, totalClean:Int, totalStimulation:Int, totalSolidity:Int, totalAfterfeel:Int, totalSpicy: Int, totalAmount: Int, totalTaste: Int, totalSugar: Int
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.reviewRate = (try? container.decode(Int.self, forKey: .reviewRate)) ?? 0
        self.totalScent = (try? container.decode(Int.self, forKey: .totalScent)) ?? 0
        self.totalClean = (try? container.decode(Int.self, forKey: .totalClean)) ?? 0
        self.totalStimulation = (try? container.decode(Int.self, forKey: .totalStimulation)) ?? 0
        self.totalSolidity = (try? container.decode(Int.self, forKey: .totalSolidity)) ?? 0
        self.totalAfterfeel = (try? container.decode(Int.self, forKey: .totalAfterfeel)) ?? 0
        self.totalSpicy = (try? container.decode(Int.self, forKey: .totalSpicy)) ?? 0
        self.totalAmount = (try? container.decode(Int.self, forKey: .totalAmount)) ?? 0
        self.totalTaste = (try? container.decode(Int.self, forKey: .totalTaste)) ?? 0
        self.totalSugar = (try? container.decode(Int.self, forKey: .totalSugar)) ?? 0
    }
}
struct itemOnlinePrice: Codable {
    let marketName: String, marketLogo: String, marketPice: Int, marketLink: String, deliverFee: Int
}

//
//  SearchModel.swift
//  BG_iOS
//
//  Created by 우진 on 2023/05/27.
//

import Foundation


struct ShopLink: Codable {
    let list: String
}

struct ShopInfo: Codable {
    let enuri: ShopLink?
    let danawa: ShopLink?
    let naver: ShopLink?
}

struct SearchItemInfo: Codable {
    let itemName: String
    
    enum CodingKeys: String, CodingKey {
        case itemName = "item_name"
    }
}

struct SearchResponseData: Codable {
    let item: SearchItemInfo
    let shop: ShopInfo
}

struct SearchAPIResponse: Codable {
    let success: Bool
    let response: SearchResponseData
    let error: String?
}

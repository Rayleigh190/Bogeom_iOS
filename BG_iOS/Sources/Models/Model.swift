//
//  Model.swift
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


// 인기 검색 상품 모델
struct HotItem: Codable {
    let itemName: String
    let itemSearchCount: Int
    
    enum CodingKeys: String, CodingKey {
        case itemName = "item_name"
        case itemSearchCount = "item_search_count"
    }
}

struct HotItemResponseData: Codable {
    let items: [HotItem]
}

struct HotItemAPIResponse: Codable {
    let success: Bool
    let response: HotItemResponseData
    let error: String?
}


// 블로그 리뷰 검색 모델
struct BlogReview: Codable {
    let title: String
    let link: String
    let description: String
    let bloggername: String
    let bloggerlink: String
    let postdate: String
}

struct ReviewResponseData: Codable {
    let reviews: [BlogReview]
}

struct BlogReviewAPIResponse: Codable {
    let success: Bool
    let blog: ReviewResponseData
    let error: String?
}

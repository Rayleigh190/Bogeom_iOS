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


// 특정 문자열이 포함된 상품 검색
struct ItemInfo: Codable {
    let id: Int
    let itemName: String
    let itemImg: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case itemName = "item_name"
        case itemImg = "item_img"
    }
}

struct ItemResponseData: Codable {
    let items: [ItemInfo]
}

struct ItemAPIResponse: Codable {
    let success: Bool
    let response: ItemResponseData
    let error: String?
}


// 주변 상점 상품 건색 모델
struct MarketItem: Codable {
    let itemName: String
    let itemPrice: Int
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case itemName = "item_name"
        case itemPrice = "item_price"
        case updatedAt = "updated_at"
    }
}

struct MarketCoord: Codable {
    let lat: Double
    let lon: Double
}

struct MarketInfo: Codable {
    let marketName: String
    let marketCoords: MarketCoord
    let marketAddress: String
    let shopLogo: String?
    let item: MarketItem
    
    enum CodingKeys: String, CodingKey {
        case marketName = "market_name"
        case marketCoords = "market_coords"
        case marketAddress = "market_address"
        case shopLogo = "shop_logo"
        case item
        
    }
}

struct ShopResponseData: Codable {
    let markets: [MarketInfo]
}

struct ShopAPIResponse: Codable {
    let success: Bool
    let response: ShopResponseData
    let error: String?
}


// 블로그 리뷰 요약 모델
struct GptResponse: Codable {
    let success: Bool
    let result: String
    let error: String?
}

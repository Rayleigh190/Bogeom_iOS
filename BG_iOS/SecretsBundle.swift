//
//  SecretsBundle.swift
//  BG_iOS
//
//  Created by 우진 on 2023/05/27.
//

import Foundation

extension Bundle {
    
    func getSecret(name: String) -> String {
        guard let file = self.path(forResource: "Secrets", ofType: "plist") else{return ""}
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource[name] as? String else {fatalError("\(name) error")}
        return key
    }
    var BASE_API_URL: String? {
        guard let file = self.path(forResource: "Secrets", ofType: "plist") else{return ""}
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["BASE_API_URL"] as? String else {fatalError("BASE_API_URL error")}
        return key
    }
    var CAMERA_SEARCH_API_URL: String? {
        guard let file = self.path(forResource: "Secrets", ofType: "plist") else{return ""}
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["CAMERA_SEARCH_API_URL"] as? String else {fatalError("CAMERA_SEARCH_API_URL error")}
        return key
    }
    
    
    var HOT_ITEM_API_URL: String? {
        guard let file = self.path(forResource: "Secrets", ofType: "plist") else{return ""}
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["HOT_ITEM_API_URL"] as? String else {fatalError("HOT_ITEM_API_URL error")}
        return key
    }
    var TEXT_SEARCH_API_URL: String? {
        guard let file = self.path(forResource: "Secrets", ofType: "plist") else{return ""}
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["TEXT_SEARCH_API_URL"] as? String else {fatalError("TEXT_SEARCH_API_URL error")}
        return key
    }
    var MAIN_API_URL: String? {
        guard let file = self.path(forResource: "Secrets", ofType: "plist") else{return ""}
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["MAIN_API_URL"] as? String else {fatalError("MAIN_API_URL error")}
        return key
    }
    var CHAT_URL: String? {
        guard let file = self.path(forResource: "Secrets", ofType: "plist") else{return ""}
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["CHAT_URL"] as? String else {fatalError("CHAT_URL error")}
        return key
    }
    var GPT_API_URL: String? {
        guard let file = self.path(forResource: "Secrets", ofType: "plist") else{return ""}
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["GPT_API_URL"] as? String else {fatalError("GPT_API_URL error")}
        return key
    }
}

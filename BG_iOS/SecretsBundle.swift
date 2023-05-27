//
//  SecretsBundle.swift
//  BG_iOS
//
//  Created by 우진 on 2023/05/27.
//

import Foundation

extension Bundle {
    
    var AI_API_URL: String? {
        guard let file = self.path(forResource: "Secrets", ofType: "plist") else{return ""}
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["AI_API_URL"] as? String else {fatalError("AI_API_URL error")}
        return key
    }
    
}

//
//  Product.swift
//  VarkaAPP
//
//  Created by Evgeny Novgorodov on 05.03.2021.
//

import Foundation
import Firebase

struct Product {
    let code: String
    let title: String
    let producer: String
    let category: String
    let cookingTime: Int
    let weight: Int?
    let isNeedStir: Bool?
    let intoBoilingWater: Bool?
    let needStirring: Bool?
    let ref: DatabaseReference?
    
    init?(snapshot: DataSnapshot) {
        guard let snapshotValue = snapshot.value as? [String: AnyObject] else { return nil }
        
        code = snapshotValue["code"] as! String
        title = snapshotValue["title"] as! String
        producer = snapshotValue["producer"] as! String
        category = snapshotValue["category"] as! String
        cookingTime = snapshotValue["cookingTime"] as! Int
        weight = snapshotValue["weight"] as? Int
        isNeedStir = snapshotValue["isNeedStir"] as? Bool
        intoBoilingWater = snapshotValue["intoBoilingWater"] as? Bool
        needStirring = snapshotValue["needStirring"] as? Bool
        ref = snapshot.ref
    }
}

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
    let weight: Int?
    let cookingTime: Int
    let intoBoilingWater: Bool?
    let needStirring: Bool?
    let ref: DatabaseReference?
    
    init(code: String, title: String, producer: String, category: String, weight: Int?, cookingTime: Int, intoBoilingWater: Bool?, needStirring: Bool?, ref: DatabaseReference? = nil) {
        self.code = code
        self.title = title
        self.producer = producer
        self.category = category
        self.cookingTime = cookingTime
        self.weight = weight
        self.intoBoilingWater = intoBoilingWater
        self.needStirring = needStirring
        self.ref = ref
    }
    
    init?(snapshot: DataSnapshot) {
        guard let snapshotValue = snapshot.value as? [String: AnyObject] else { return nil }
        
        code = snapshotValue["code"] as! String
        title = snapshotValue["title"] as! String
        producer = snapshotValue["producer"] as! String
        category = snapshotValue["category"] as! String
        weight = snapshotValue["weight"] as? Int
        cookingTime = snapshotValue["cookingTime"] as! Int
        intoBoilingWater = snapshotValue["intoBoilingWater"] as? Bool
        needStirring = snapshotValue["needStirring"] as? Bool
        ref = snapshot.ref
    }
}

extension Product {
    
    static func getProducts() -> [Product] {
        [Product(
            code: "1234567890123", title: "Rice", producer: "Agro-Alliance",
            category: "Grocery", weight: 800, cookingTime: 600,
            intoBoilingWater: true, needStirring: false
        ),
        Product(
            code: "9876543210987", title: "Buckwheat", producer: "Agro-Alliance",
            category: "Grocery", weight: 900, cookingTime: 420,
            intoBoilingWater: false, needStirring: false
        )]
    }
}

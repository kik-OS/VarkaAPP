//
//  Product.swift
//  VarkaAPP
//
//  Created by Evgeny Novgorodov on 05.03.2021.
//

import Foundation
import Firebase

struct Product {
    
    // MARK: - Properties
    
    let code: String
    let title: String
    let producer: String
    let category: String
    let weight: Int?
    let cookingTime: Int
    let intoBoilingWater: Bool?
    let needStirring: Bool?
    let ref: DatabaseReference?
    
    // MARK: - Initializers
    
    init(code: String, title: String, producer: String, category: String, weight: Int?, cookingTime: Int, intoBoilingWater: Bool?, needStirring: Bool?, ref: DatabaseReference? = nil) {
        self.code = code
        self.title = title
        self.producer = producer
        self.category = category
        self.weight = weight
        self.cookingTime = cookingTime
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
    
    // MARK: - Public methods
    
    func convertToDictionaty() -> Any {
        ["code": code,
         "title": title,
         "producer": producer,
         "category": category,
         "weight": weight as Any,
         "cookingTime": cookingTime,
         "intoBoilingWater": intoBoilingWater as Any,
         "needStirring": needStirring as Any,
         "ref": ref as Any]
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
        ),
        Product(
            code: "AB1234567890C", title: "Pelmeni", producer: "Brothers",
            category: "Semifinished", weight: 1000, cookingTime: 360,
            intoBoilingWater: true, needStirring: true
        )]
    }
}

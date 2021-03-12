//
//  Product.swift
//  VarkaAPP
//
//  Created by Evgeny Novgorodov on 05.03.2021.
//

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
    let waterRatio: Double
    let ref: DatabaseReference?
    
    // MARK: - Initializers
    
    init(code: String, title: String, producer: String, category: String, weight: Int?,
         cookingTime: Int, intoBoilingWater: Bool?, needStirring: Bool?, waterRatio: Double, ref: DatabaseReference? = nil) {
        self.code = code
        self.title = title
        self.producer = producer
        self.category = category
        self.weight = weight
        self.cookingTime = cookingTime
        self.intoBoilingWater = intoBoilingWater
        self.needStirring = needStirring
        self.waterRatio = waterRatio
        self.ref = ref
    }
    
    init?(snapshot: DataSnapshot) {
        guard let snapshotValue = snapshot.value as? [String: AnyObject],
              let code = snapshotValue["code"] as? String,
              let title = snapshotValue["title"] as? String,
              let producer = snapshotValue["producer"] as? String,
              let category = snapshotValue["category"] as? String,
              let cookingTime = snapshotValue["cookingTime"] as? Int,
              let waterRatio = snapshotValue["waterRatio"] as? Double
              else { return nil }
        
        self.code = code
        self.title = title
        self.producer = producer
        self.category = category
        self.weight = snapshotValue["weight"] as? Int
        self.cookingTime = cookingTime
        self.intoBoilingWater = snapshotValue["intoBoilingWater"] as? Bool
        self.needStirring = snapshotValue["needStirring"] as? Bool
        self.waterRatio = waterRatio
        self.ref = snapshot.ref
    }
    
    // MARK: - Public methods
    
    func convertToDictionary() -> Any {
        ["code": code,
         "title": title,
         "producer": producer,
         "category": category,
         "weight": weight as Any,
         "cookingTime": cookingTime,
         "intoBoilingWater": intoBoilingWater as Any,
         "needStirring": needStirring as Any,
         "waterRatio": waterRatio,
         "ref": ref as Any]
    }
}

extension Product {
    
    static func getProducts() -> [Product] {
        [Product(
            code: "1234567890000", title: "Рис круглозёрный", producer: "Агро-Альянс",
            category: "Бакалея", weight: 800, cookingTime: 10,
            intoBoilingWater: true, needStirring: false, waterRatio: 3
        ),
        Product(
            code: "0987654321098", title: "Гречка", producer: "Агро-Альянс",
            category: "Бакалея", weight: 900, cookingTime: 7,
            intoBoilingWater: false, needStirring: false, waterRatio: 2.2
        ),
        Product(
            code: "AB1234567890D", title: "Пельмени", producer: "Братцы-вареники",
            category: "Полуфабрикаты", weight: 1000, cookingTime: 6,
            intoBoilingWater: true, needStirring: true, waterRatio: 1
        )]
    }
}

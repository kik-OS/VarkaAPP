//
//  Category.swift
//  VarkaAPP
//
//  Created by Evgeny Novgorodov on 11.03.2021.
//

import Firebase

struct Category {
    
    // MARK: - Class properties
    
    static private var idIterator = 0
    
    // MARK: - Class methods
    
    static private func getID() -> Int {
        idIterator += 1
        return idIterator
    }
    
    // MARK: - Properties
    
    let id: Int
    let name: String
    let imageName: String
    let date: Date
    
    // MARK: - Initializers
    
    init(name: String) {
        self.id = Category.getID()
        self.name = name
        self.imageName = name
        self.date = Date()
    }
    
    init?(snapshot: DataSnapshot) {
        guard let snapshotValue = snapshot.value as? [String: AnyObject],
              let stringDate = snapshotValue["date"] as? String else { return nil }
        
        id = snapshotValue["id"] as! Int
        name = snapshotValue["name"] as! String
        imageName = snapshotValue["imageName"] as! String
        date = DateFormatter.firebaseDateFormatter.date(from: stringDate) ?? Date()
    }
    
    // MARK: - Public methods
    
    func convertToDictionaty() -> Any {
        ["id": id,
         "name": name,
         "imageName": imageName,
         "date": DateFormatter.firebaseDateFormatter.string(from: date)]
    }
}

extension Category {
    
    static func getCategories() -> [Category] {
        Constants.categoryNames.map { Category(name: $0) }
    }
}

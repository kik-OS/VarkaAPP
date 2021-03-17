//
//  StorageManager.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 12.03.2021.
//

import Foundation

import CoreData

class StorageManager {
    
    static let shared = StorageManager()
    
    // MARK: - Core Data stack
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "VarkaAPP")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private init() {}
    
    // MARK: - Public Methods
    func fetchData() -> [ProductCD] {
        let fetchRequest: NSFetchRequest<ProductCD> = ProductCD.fetchRequest()
        
        do {
            return try viewContext.fetch(fetchRequest)
        } catch let error {
            print("Failed to fetch data", error)
            return []
        }
    }
    
    // Save data
    func saveProductCD(product: Product) {
        
        
        let productCD = ProductCD(context: viewContext)
        productCD.code = product.code
        productCD.title = product.title
        productCD.producer = product.producer
        productCD.category = product.category
        productCD.cookingTime = Int64(product.cookingTime)
        productCD.waterRatio = product.waterRatio
        productCD.date = Date()
        
        if let productWeight = product.weight,
           let productNeedStirring = product.needStirring,
           let productIntoBoilingWater = product.intoBoilingWater {
            productCD.weight = Int64(productWeight)
            productCD.needsStirring = productNeedStirring
            productCD.intoBoilingWater = productIntoBoilingWater
        }
        saveContext()
    }
    
   
    func deleteProductCD(_ productCD: ProductCD) {
        viewContext.delete(productCD)
        saveContext()
    }

    // MARK: - Core Data Saving support
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

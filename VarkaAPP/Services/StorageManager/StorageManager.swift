//
//  StorageManager.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 12.03.2021.
//

import CoreData

final class StorageManager {
    
    // MARK: - Static properties
    
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
    
    // MARK: - Initializers
    
    private init() {}
    
    // MARK: - Public methods
    
    func fetchData() -> [ProductCD] {
        let fetchRequest: NSFetchRequest<ProductCD> = ProductCD.fetchRequest()
        
        do {
            return try viewContext.fetch(fetchRequest)
        } catch let error {
            print("Failed to fetch data", error)
            return []
        }
    }
    
    func saveProductCD(product: Product) {
        fetchData().forEach { if $0.code == product.code {deleteProductCD($0)} }
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
    
    func convertFromProductCDToProduct(productCD: ProductCD) -> Product? {
        guard let code = productCD.code,
              let title = productCD.title,
              let producer = productCD.producer,
              let category = productCD.category else { return nil }
        return Product(code: code, title: title, producer: producer,
                       category: category, weight: Int(productCD.weight),
                       cookingTime: Int(productCD.cookingTime),
                       intoBoilingWater: true, needStirring: productCD.needsStirring,
                       waterRatio: productCD.waterRatio)
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
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

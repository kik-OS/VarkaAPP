//
//  FirebaseService.swift
//  VarkaAPP
//
//  Created by Evgeny Novgorodov on 06.03.2021.
//

import FirebaseDatabase

// MARK: - Protocols

protocol FirebaseServiceProtocol {
    func saveProduct(_ product: Product)
    func saveProducts(_ products: [Product])
    func fetchProduct(byCode code: String,
                      completion: @escaping (Result<Product, FirebaseServiceError>) -> Void)
    func fetchProducts(completion: @escaping (Result<[Product], Error>) -> Void)
    func removeProduct(byCode code: String)
    func saveCategories(_ categories: [Category])
    func fetchCategories(completion: @escaping ([Category]) -> Void)
}

final class FirebaseService: FirebaseServiceProtocol {
    
    // MARK: - Class properties
    
    static let shared = FirebaseService()
    
    // MARK: - Properties
    
    private let ref = Database.database().reference()
    
    // MARK: - Initializers
    
    private init() {}
    
    // MARK: - Public methods
    
    func saveProduct(_ product: Product) {
        ref.child("products").child(product.code).setValue(product.convertToDictionary())
    }
    
    func saveProducts(_ products: [Product]) {
        products.forEach {
            ref.child("products").child($0.code).setValue($0.convertToDictionary())
        }
    }
    
    func fetchProduct(byCode code: String,
                      completion: @escaping (Result<Product, FirebaseServiceError>) -> Void) {
        ref.child("products").child(code).observe(.value) { snapshot in
            guard snapshot.exists() else {
                completion(.failure(.productNotFound))
                return
            }
            guard let product = Product(snapshot: snapshot) else {
                completion(.failure(.modelInitializingError))
                return
            }
            completion(.success(product))
        }
    }
    
    func fetchProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        ref.child("products").observe(.value) { snapshot in
            let products = snapshot.children.compactMap { Product(snapshot: $0 as! DataSnapshot) }
            completion(.success(products))
        }
    }
    
    func removeProduct(byCode code: String) {
        ref.child("products").child(code).removeValue()
    }
    
    func saveCategories(_ categories: [Category]) {
        categories.forEach {
            ref.child("categories").child($0.name).setValue($0.convertToDictionaty())
        }
    }
    
    func fetchCategories(completion: @escaping ([Category]) -> Void) {
        ref.child("categories").observe(.value) { snapshot in
            let categories = snapshot.children.compactMap { Category(snapshot: $0 as! DataSnapshot) }
            completion(categories)
        }
    }
}

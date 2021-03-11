//
//  FirebaseService.swift
//  VarkaAPP
//
//  Created by Evgeny Novgorodov on 06.03.2021.
//

import Foundation
import FirebaseCore
import Firebase
import FirebaseDatabase

// MARK: - Protocols

protocol FirebaseServiceProtocol {
    func saveProduct(_ product: Product)
    func saveProducts(_ products: [Product])
    func fetchProduct(byCode code: String, completion: @escaping (Result<Product?, Error>) -> Void)
    func fetchProducts(completion: @escaping (Result<[Product], Error>) -> Void)
    func removeProduct(byCode code: String)
}

final class FirebaseService: FirebaseServiceProtocol {
    
    // MARK: - Initializer
    
    static let shared = FirebaseService()
    private init() {}
    
    // MARK: - Properties
    
    private let ref = Database.database().reference()
    
    
    // MARK: - Public methods
    
    internal func saveProduct(_ product: Product) {
        ref.child("products").child(product.code).setValue(product.convertToDictionary())
    }
    
    internal func saveProducts(_ products: [Product]) {
        products.forEach {
            ref.child("products").child($0.code).setValue($0.convertToDictionary())
        }
    }
    
    internal func fetchProduct(byCode code: String, completion: @escaping (Result<Product?, Error>) -> Void) {
        ref.child("products").child(code).observe(.value) { snapshot in
            completion(.success(Product(snapshot: snapshot)))
        }
    }
    
    internal func fetchProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        ref.child("products").observe(.value) { snapshot in
            let products = snapshot.children.compactMap { Product(snapshot: $0 as! DataSnapshot) }
            completion(.success(products))
        }
    }
    
    internal func removeProduct(byCode code: String) {
        ref.child("products").child(code).removeValue()
    }
}

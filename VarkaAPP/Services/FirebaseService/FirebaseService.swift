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
//    func saveProducts(_ products: [Product])
//    func fetchProduct(byCode code: String, completion: @escaping (Result<Product?, Error>) -> Void)
//    func fetchProducts(completion: @escaping (Result<[Product], Error>) -> Void)
}

final class FirebaseService: FirebaseServiceProtocol {
    
    // MARK: - Properties
    
    private let ref = Database.database().reference()
    
    
    // MARK: - Public methods
    
    func saveProducts(_ products: [Product]) {
        products.forEach {
            ref.child("products").child($0.code).setValue($0.convertToDictionaty())
        }
    }
    
//    func fetchProduct(byCode code: String, completion: @escaping (Result<Product?, Error>) -> Void) {
//        ref.child("products").child(code).getData { (error, snapshot) in
//            if let error = error {
//                print("Error getting data \(error)")
//                completion(.failure(error))
//            }
//            else if snapshot.exists() {
//                let product = Product(snapshot: snapshot)
//
//                completion(.success(product))
//            } else {
//                print("No data available")
//                completion(.success(nil))
//            }
//        }
//    }
    
//    func fetchProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
//        ref.child("products").getData { (error, snapshot) in
//            if let error = error {
//                print("Error getting data \(error)")
//                completion(.failure(error))
//            }
//            else if snapshot.exists() {
//                guard let productsData = snapshot.value as? [String: Any] else {
//                    print("Data format is incorrect")
//                    completion(.success([]))
//                    return
//                }
//
//                let products = productsData.keys.compactMap { Product(snapshot: snapshot.childSnapshot(forPath: $0)) }
//
//                completion(.success(products))
//            } else {
//                print("No data available")
//                completion(.success([]))
//            }
//        }
//    }
}

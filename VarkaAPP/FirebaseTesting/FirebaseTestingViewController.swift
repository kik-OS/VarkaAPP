//
//  FirebaseTestingViewController.swift
//  VarkaAPP
//
//  Created by Evgeny Novgorodov on 06.03.2021.
//

import UIKit
import Firebase

final class FirebaseTestingViewController: UIViewController {
    
    private let firebaseService: FirebaseServiceProtocol = FirebaseService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newProduct = Product(
            code: "4607016244682", title: "Чечевица зелёная", producer: "Увелка",
            category: "Бакалея", weight: 500, cookingTime: 720,
            intoBoilingWater: true, needStirring: true
        )
        
        firebaseService.saveProduct(newProduct)
        
//        firebaseService.saveProducts(Product.getProducts())
        
        firebaseService.fetchProducts { result in
            switch result {
            case .success(let products):
                print(products)
            case .failure:
                break
            }
        }
        
        firebaseService.fetchProduct(byCode: "AB1234567890C") { result in
            switch result {
            case .success(let product):
                print(product ?? "Not fetched")
            case .failure:
                break
            }
        }
        
//        firebaseService.removeProduct(byCode: "9876543210987")
    }
}

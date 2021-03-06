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
        
//        firebaseService.fetchProducts { result in
//            switch result {
//            case .success(let products):
//                print(products)
//            case .failure:
//                break
//            }
//        }
        
//        firebaseService.fetchProduct(byCode: "AB1234567890C") { result in
//            switch result {
//            case .success(let product):
//                print(product ?? "Not fetched")
//            case .failure:
//                break
//            }
//        }
    }
}

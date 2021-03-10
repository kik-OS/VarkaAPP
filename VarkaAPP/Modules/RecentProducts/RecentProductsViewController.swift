//
//  RecentProductsViewController.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 05.03.2021.
//

import UIKit

class RecentProductsViewController: UIViewController {
    @IBOutlet weak var recentProductLabel: UILabel!
    
    private var recentProductCollectionView = RecentProductCollectionView()
    
    var products: [Product] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchDataFromFireBase()
        
        view.addSubview(recentProductCollectionView)
        
        recentProductCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        recentProductCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        recentProductCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        recentProductCollectionView.topAnchor.constraint(equalTo: recentProductLabel.bottomAnchor, constant: 10).isActive = true
        recentProductCollectionView.heightAnchor.constraint(equalToConstant: 350).isActive = true
    }
    
    
    func fetchDataFromFireBase() {
        let firebaseService: FirebaseServiceProtocol = FirebaseService()
        firebaseService.fetchProducts { result in
            switch result {
            case .success(let products):
                self.products = products
                self.recentProductCollectionView.set(products: products)
                DispatchQueue.main.async {
                    self.recentProductCollectionView.reloadData()
                }
            case .failure(_):
                break
            }
        }
    }
}


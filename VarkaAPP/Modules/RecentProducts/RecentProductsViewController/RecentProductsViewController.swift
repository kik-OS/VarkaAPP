//
//  RecentProductsViewController.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 05.03.2021.
//

import UIKit

class RecentProductsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var recentProductLabel: UILabel!
    @IBOutlet weak var nothingFoundLabel: UILabel!
    
    // MARK: - Properties
    
    private var recentProductCollectionView = RecentProductCollectionView()
    private var viewModel: RecentProductViewModelProtocol!
    
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        StorageManager.shared.saveProductCD(code: "123456", title: "Тестовый2", producer: "test", category: "Макароны", weight: 10, cookingTime: 10, intoBoilingWater: nil, needStirring: nil, waterRatio: 2, date: Date())
//
//        StorageManager.shared.saveProductCD(code: "123456994", title: "Тестовый3", producer: "test2", category: "Макароны", weight: 10, cookingTime: 10, intoBoilingWater: nil, needStirring: nil, waterRatio: 2, date: Date())
        
        
//        let test: [ProductCD] = StorageManager.shared.fetchData()
//
//        for i in test {
//            StorageManager.shared.deleteProductCD(i)
//        }
        
        
        
        
        view.addSubview(recentProductCollectionView)
        configureConstraints()
        //Переделать 
        recentProductCollectionView.viewModel = RecentProductCollectionViewViewModel()
    }
    
    // MARK: - Private methods
    
   private func configureConstraints() {
        recentProductCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        recentProductCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        recentProductCollectionView.topAnchor.constraint(equalTo: recentProductLabel.bottomAnchor,
                                                         constant: 10).isActive = true
        recentProductCollectionView.heightAnchor.constraint(equalToConstant: 350).isActive = true
    }
}


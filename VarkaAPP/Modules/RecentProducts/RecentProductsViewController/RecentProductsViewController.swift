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
    
    var recentProductCollectionView = RecentProductCollectionView()
    //    private var viewModel: RecentProductViewModelProtocol!
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let test: [ProductCD] = StorageManager.shared.fetchData()
        //
        //        for i in test {
        //            StorageManager.shared.deleteProductCD(i)
        //        }
        
        view.addSubview(recentProductCollectionView)
        configureConstraints()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recentProductCollectionView.viewModel.fetchProductFromCoreData { [ weak self] in
            self?.recentProductCollectionView.reloadData()
        }
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


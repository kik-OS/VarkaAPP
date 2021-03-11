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
    
    private var viewModel: RecentProductViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(recentProductCollectionView)
        configureConstraints()
        
        //Переделать 
        recentProductCollectionView.viewModel = RecentProductCollectionViewViewModel()
    }
    
    
   private func configureConstraints() {
        recentProductCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        recentProductCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        recentProductCollectionView.topAnchor.constraint(equalTo: recentProductLabel.bottomAnchor,
                                                         constant: 10).isActive = true
        recentProductCollectionView.heightAnchor.constraint(equalToConstant: 350).isActive = true
    }
}


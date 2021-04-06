//
//  RecentProductsViewController.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 05.03.2021.
//

import UIKit

protocol RecentProductCollectionViewDelegate {
    func presentInfoAboutProduct(product: Product)
}

final class RecentProductsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var recentProductLabel: UILabel!
    @IBOutlet weak var nothingFoundStack: UIStackView!
    // MARK: - Properties
    
    var recentProductCollectionView = RecentProductCollectionView()
    var viewModel: RecentProductViewModelProtocol!
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(recentProductCollectionView)
        configureConstraints()
        recentProductCollectionView.viewModel = viewModel.getRecentProductCollectionViewViewModel()
        recentProductCollectionView.viewModel.delegate = self
        view.backgroundColor = VarkaColors.mainColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recentProductCollectionView.viewModel.fetchProductFromCoreData { [ weak self] in
            self?.recentProductCollectionView.reloadData()
            guard let isHidden = self?.recentProductCollectionView.viewModel.contentIsEmpty() else {return}
            self?.recentProductCollectionView.isHidden = isHidden
            self?.nothingFoundStack.isHidden = !isHidden
        }
    }
    
    // MARK: - Private methods
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            recentProductCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recentProductCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recentProductCollectionView.topAnchor.constraint(equalTo: recentProductLabel.bottomAnchor,
                                                             constant: 10),
            recentProductCollectionView.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: view.frame.height / 5)
        ])
    }
}

extension RecentProductsViewController: RecentProductCollectionViewDelegate {
    func presentInfoAboutProduct(product: Product) {
        let productInfoViewModel = viewModel.getProductInfoViewModel(product: product)
        guard let productInfoVC = tabBarController?.viewControllers?.first as? ProductInfoViewController else { return }
        productInfoVC.viewModel = productInfoViewModel
        tabBarController?.selectedViewController = tabBarController?.viewControllers?.first
    }
}

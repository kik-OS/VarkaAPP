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
        addVerticalGradientLayer(topColor: #colorLiteral(red: 0.9470130801, green: 0.8945655227, blue: 0.7866981626, alpha: 1) , bottomColor: .white)
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
    
    func addVerticalGradientLayer(topColor: UIColor, bottomColor: UIColor) {
           let gradient = CAGradientLayer()
           gradient.frame = view.bounds
           gradient.colors = [topColor.cgColor, bottomColor.cgColor]
           gradient.locations = [0.0, 1.0]
           gradient.startPoint = CGPoint(x: 0, y: 0)
           gradient.endPoint = CGPoint(x: 0, y: 1)
           view.layer.insertSublayer(gradient, at: 0)
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

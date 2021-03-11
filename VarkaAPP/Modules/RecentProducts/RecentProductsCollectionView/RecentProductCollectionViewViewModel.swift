//
//  RecentProductCollectionViewViewModel.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 11.03.2021.
//

import Foundation

protocol RecentProductCollectionViewViewModelProtocol {
    func cellViewModel(at indexPath: IndexPath) -> RecentProductCollectionViewCellViewModelProtocol?
    func fetchProducts(completion: @escaping() -> Void)
    var products: [Product] { get }
    var numberOfItemsInSection: Int { get }
}


class RecentProductCollectionViewViewModel: RecentProductCollectionViewViewModelProtocol {
    
    var products: [Product] = []
    
    var numberOfItemsInSection: Int {
        products.count
    }
    
    func fetchProducts(completion: @escaping () -> Void) {
            FirebaseService.shared.fetchProducts { [weak self] result in
                switch result {
                case .success(let products):
                    self?.products = products
                    DispatchQueue.main.async {
                        completion()
                    }
                case .failure(_):
                    break
                }
            }
        }
    
    func cellViewModel(at indexPath: IndexPath) -> RecentProductCollectionViewCellViewModelProtocol? {
        let product = products[indexPath.row]
        return RecentProductCollectionViewCellViewModel(product: product)
    }
}

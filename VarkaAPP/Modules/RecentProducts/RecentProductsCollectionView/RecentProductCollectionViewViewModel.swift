//
//  RecentProductCollectionViewViewModel.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 11.03.2021.
//

import Foundation

protocol RecentProductCollectionViewViewModelProtocol: class {
    var numberOfItemsInSection: Int { get }
    var productsCD: [ProductCD] { get }
    func fetchProductFromCoreData(completion: @escaping() -> Void)
    func cellViewModel(at indexPath: IndexPath) -> RecentProductCollectionViewCellViewModelProtocol?
}


class RecentProductCollectionViewViewModel: RecentProductCollectionViewViewModelProtocol {
    
    // MARK: - Properties
    
    var productsCD: [ProductCD] = []
    var numberOfItemsInSection: Int {
        productsCD.count
    }
    
    // MARK: - Methods
    
    func fetchProductFromCoreData(completion: @escaping() -> Void) {
        productsCD = StorageManager.shared.fetchData()
        DispatchQueue.main.async {
            completion()
        }
    }
    
    func cellViewModel(at indexPath: IndexPath) -> RecentProductCollectionViewCellViewModelProtocol? {
        let product = productsCD[indexPath.row]
        return RecentProductCollectionViewCellViewModel(product: product)
    }
}

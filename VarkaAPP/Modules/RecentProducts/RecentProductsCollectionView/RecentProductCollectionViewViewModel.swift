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
    var delegate: RecentProductCollectionViewDelegate! { get set }
    func fetchProductFromCoreData(completion: @escaping() -> Void)
    func cellViewModel(at indexPath: IndexPath) -> RecentProductCollectionViewCellViewModelProtocol?
    func didSelectItemAt(indexPath: IndexPath)
    func contentIsEmpty() -> Bool
}

final class RecentProductCollectionViewViewModel: RecentProductCollectionViewViewModelProtocol {
    func contentIsEmpty() -> Bool {
        numberOfItemsInSection == 0
    }
    
    func didSelectItemAt(indexPath: IndexPath) {
        guard let product = StorageManager.shared.convertFromProductCDToProduct(productCD: productsCD[indexPath.row]) else { return }
        delegate.presentInfoAboutProduct(product: product)
    }
    
    // MARK: - Properties
    
    var productsCD: [ProductCD] = []
    var delegate: RecentProductCollectionViewDelegate!
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

//
//  RecentProductCollectionViewCellViewModel.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 11.03.2021.
//

import Foundation

protocol RecentProductCollectionViewCellViewModelProtocol {
    var productTitle: String? { get }
    var productProducer: String? { get }
    var productImage: String { get }
    var productCookingTime: String?  { get }
    var productBarcode: String { get }
    var productWeight: String { get }
    init(product: ProductCD)
}

final class RecentProductCollectionViewCellViewModel: RecentProductCollectionViewCellViewModelProtocol {
    var productWeight: String {
        "\(product.weight) грамм"
    }
    
    var productBarcode: String {
        product.code ?? ""
    }
    
    // MARK: - Properties
    
    var productTitle: String? {
        product.title
    }
    
    var productProducer: String? {
        product.producer
    }
    
    var productImage: String {
        "\(product.category ?? "").png"
    }
    
    var productCookingTime: String? {
        "\(product.cookingTime)мин.⏱"
    }
    
    private let product: ProductCD
    
    // MARK: - Initializer
    
    required init(product: ProductCD) {
        self.product = product
    }
}

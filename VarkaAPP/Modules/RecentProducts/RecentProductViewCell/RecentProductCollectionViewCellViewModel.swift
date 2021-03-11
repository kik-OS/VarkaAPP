//
//  RecentProductCollectionViewCellViewModel.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 11.03.2021.
//

import Foundation

protocol RecentProductCollectionViewCellViewModelProtocol {
    var productTitle: String { get }
    var productProducer: String { get }
    var productImage: String { get }
    init(product: Product)
}

class RecentProductCollectionViewCellViewModel: RecentProductCollectionViewCellViewModelProtocol {
    var productTitle: String {
        product.title
    }
    
    var productProducer: String {
        product.producer
    }
    
    var productImage: String {
        "rice.png"
    }
    
    private let product: Product
    
    required init(product: Product) {
        self.product = product
    }
    
    
}

//
//  ProductInfoViewModel.swift
//  VarkaAPP
//
//  Created by Evgeny Novgorodov on 09.03.2021.
//

import Foundation

protocol ProductInfoViewModelProtocol {
    var product: Box<Product?> { get }
    var weight: String { get }
    var cookingTime: String { get }
    var intoBoilingWater: String { get }
    var needStirring: String { get }
    var isHiddenProductStackView: Bool { get }
    
    init(product: Product?)
}

final class ProductInfoViewModel: ProductInfoViewModelProtocol {
    
    // MARK: - Properties
    
    var product: Box<Product?> = Box(nil)
    
    var weight: String {
        guard let weight = product.value?.weight else {
            return "Н/Д"
        }
        return "\(weight) гр"
    }
    
    var cookingTime: String {
        let cookingTime = (product.value?.cookingTime ?? 0) / 60
        return "\(cookingTime) мин"
    }
    
    var intoBoilingWater: String {
        product.value?.intoBoilingWater ?? false
            ? "Необходимо бросать в кипящую воду"
            : "Можно бросать в холодную воду"
    }
    
    var needStirring: String {
        product.value?.needStirring ?? false
            ? "Требуется мешать во время варки"
            : "Можно не мешать"
    }
    
    var isHiddenProductStackView: Bool {
        product.value == nil
    }
    
    // MARK: - Initializers
    
    init(product: Product?) {
        self.product.value = product
    }
}

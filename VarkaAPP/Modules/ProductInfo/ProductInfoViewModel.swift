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
    var productImage: String { get }
    
    init(product: Product?)
    
    func getTimerViewModel() -> TimerViewModelProtocol
}

final class ProductInfoViewModel: ProductInfoViewModelProtocol {
   
    
    
    // MARK: - Properties
    
    var product: Box<Product?> = Box(nil)
    
    var productImage: String {
         let productImage = product.value?.category ?? ""
        return "\(productImage).png"
    }
    
    var weight: String {
        guard let weight = product.value?.weight else {
            return "Н/Д"
        }
        return "\(weight) гр"
    }
    
    var cookingTime: String {
        let cookingTime = (product.value?.cookingTime ?? 0)
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
        return product.value == nil
        
    }
    
    // MARK: - Initializers
    
    init(product: Product? = nil) {
        self.product.value = product
    }
    
    // MARK: - Public methods
    
    func getTimerViewModel() -> TimerViewModelProtocol {
        TimerViewModel(minutes: product.value?.cookingTime ?? 0)
    }
}

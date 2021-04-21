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
    var isHiddenProductStackView: Bool { get }
    var productImage: String { get }
    var firstStep: String { get }
    var secondStep: String { get }
    var thirdStep: String { get }
    
    
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
        return "\(weight) г."
    }
    
    var cookingTime: String {
        let cookingTime = (product.value?.cookingTime ?? 0)
        return "\(cookingTime) мин."
    }
    
    var needStirring: String {
        product.value?.needStirring ?? false
            ? "Требуется мешать во время варки"
            : "Можно не мешать"
    }
    
    var isHiddenProductStackView: Bool {
        return product.value == nil
    }
    
    var firstStep: String {
        let waterRatio = product.value?.waterRatio ?? 1
        return "Объем воды к продукту \(Int(waterRatio)):1"
    }
    
    var secondStep: String {
        product.value?.intoBoilingWater ?? false
            ? "Поместите продукт в кипящую воду"
            : "Поместите продукт в холодную воду"
    }
    
    var thirdStep: String {
        "Заведите таймер. Варите \(cookingTime)"
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

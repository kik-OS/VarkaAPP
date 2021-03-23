//
//  AddingNewProductViewModel.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 09.03.2021.
//

import Foundation


protocol AddingNewProductViewModelProtocol {
    var codeLabelText: String? { get set }
    var textFromCategoryTF: String? { get set }
    var textFromTitleProductTF: String? { get set }
    var textFromProducerTF: String? { get set }
    var textFromCookingTimeTF: String? { get set }
    var textFromWeightTF: String? { get set }
    var textFromWaterRatioTF: String? { get set }
    var needStirring: Bool { get set }
    var waterRatio: Double { get }
    var completedProduct: Product? { get }
    var categories: [Category] { get }
    var listOfWaterRatio: [String] { get }
    var indexOfFirstResponder: Int { get set }
    func validation() -> Bool
    func calculateWaterRatio(row: Int)
    func createProductInFB()
    func getCategories()
    func calculationOfLowerResponder() -> Int
    func calculationOfUpperResponder() -> Int
    
    init(code: String)
}

final class AddingNewProductViewModel: AddingNewProductViewModelProtocol {
    
    

    
   
    
    // MARK: - Initializers
    
    init(code: String) {
        self.codeLabelText = code
    }
    
    // MARK: - Properties
    
    var codeLabelText: String?
    var textFromCategoryTF: String?
    var textFromTitleProductTF: String?
    var textFromProducerTF: String?
    var textFromCookingTimeTF: String?
    var textFromWeightTF: String?
    var textFromWaterRatioTF: String?
    var indexOfFirstResponder: Int = 0
    var waterRatio: Double = 3
    var completedProduct: Product?
    var needStirring: Bool = true
    var categories: [Category] = []
    var listOfWaterRatio = Inscriptions.variantsOfWaterRatio
    
    // MARK: - Methods
    
    func calculateWaterRatio(row: Int) {
        waterRatio = Double(row + 1)
    }
    
    func validation() -> Bool {
        guard let code = codeLabelText,
              let _ = textFromCategoryTF,
              let productTitle = textFromTitleProductTF,
              let category = textFromCategoryTF,
              let productProducer = textFromProducerTF,
              let productCookingTime = textFromCookingTimeTF,
              let productWeight = textFromWeightTF,
              let _ = textFromWaterRatioTF else { return false }
        
        guard productTitle != "",
              productProducer != "",
              productCookingTime != "",
              productWeight != "" else { return false }
        
        guard let intCookingTime = Int(productCookingTime),
              let intWeight = Int(productWeight),
              intCookingTime > 0, intCookingTime < 121,
              intWeight > 0, intWeight < 1501,
              productTitle.count < 50,
              productProducer.count < 50 else { return false }
        
        completedProduct = Product(code: code, title: productTitle, producer: productProducer, category: category, weight: intWeight, cookingTime: intCookingTime, intoBoilingWater: true, needStirring: needStirring, waterRatio: waterRatio)
        
        return true
    }
    
    
    func getCategories() {
        FirebaseService.shared.fetchCategories { categories in
            self.categories = categories
        }
    }
    
    func createProductInFB() {
        guard let product = completedProduct else { return }
        FirebaseService.shared.saveProduct(product)
    }
        
    func calculationOfLowerResponder() -> Int {
        switch indexOfFirstResponder {
        case 0...4:
            return indexOfFirstResponder + 1
        default:
            return indexOfFirstResponder
        }
    }
    
    func calculationOfUpperResponder() -> Int {
        switch indexOfFirstResponder {
        case 1...5:
            return indexOfFirstResponder - 1
        default:
            return indexOfFirstResponder
        }
    }
}

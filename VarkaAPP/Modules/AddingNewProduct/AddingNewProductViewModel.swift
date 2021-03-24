//
//  AddingNewProductViewModel.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 09.03.2021.
//

import Foundation

protocol AddingNewProductViewModelProtocol: class {
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
    var dataForPickerView: [String] { get }
    var numberOfRowsInPickerView: Int { get }
    var needUpdateTextFieldWithPickerView: ((_ type: PickerViewForKBType, _ text: String) -> Void)? { get set }
    var needUpdateFirstResponder: ((_ tag: Int) -> Void)? { get set }
    var stateForUpButton: Bool { get }
    var stateForDownButton: Bool { get }
    init(code: String)
    func getProductInfoViewModel() -> ProductInfoViewModelProtocol
    func validation() -> Bool
    func calculateWaterRatio(row: Int)
    func createProductInFB()
    func getCategories()
    func calculationOfLowerResponder() -> Int
    func calculationOfUpperResponder() -> Int
    func updatePickerViewIfNeeded(index: Int, completion: @escaping () -> Void)
    func pickerViewDidSelectAt(row: Int)
    func didTapChangeResponderButton(type: ToolBarButtonsForKBType)
}

final class AddingNewProductViewModel: AddingNewProductViewModelProtocol {
    
    // MARK: - Initializers
    
    init(code: String) {
        self.codeLabelText = code
        getCategories()
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
    var needUpdateTextFieldWithPickerView: ((PickerViewForKBType, String) -> Void)?
    var needUpdateFirstResponder: ((Int) -> Void)?
    var numberOfRowsInPickerView: Int {
        dataForPickerView.count
    }
    var stateForUpButton: Bool {
        indexOfFirstResponder != 0
    }
    var stateForDownButton: Bool {
        indexOfFirstResponder != 5
    }
    var dataForPickerView: [String] {
        switch indexOfFirstResponder {
        case 0:
            return categories.map{$0.name}
        case 5:
            return listOfWaterRatio
        default:
            return []
        }
    }
    
    private let firebaseService: FirebaseServiceProtocol = FirebaseService.shared
    
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
        
        guard !productTitle.isEmpty,
              !productProducer.isEmpty,
              !productCookingTime.isEmpty,
              !productWeight.isEmpty else { return false }
        
        guard let intCookingTime = Int(productCookingTime),
              let intWeight = Int(productWeight),
              (0...120).contains(intCookingTime),
              (1...1500).contains(intWeight),
              productTitle.count < 50,
              productProducer.count < 50 else { return false }
        
        
        completedProduct = Product(code: code, title: productTitle,
                                   producer: productProducer, category: category,
                                   weight: intWeight, cookingTime: intCookingTime,
                                   intoBoilingWater: true, needStirring: needStirring,
                                   waterRatio: waterRatio)
        return true
    }
    
    
    func getCategories() {
        firebaseService.fetchCategories { categories in
            self.categories = categories
        }
    }
    
    func createProductInFB() {
        guard let product = completedProduct else { return }
        firebaseService.saveProduct(product)
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
    
    
    func updatePickerViewIfNeeded(index: Int, completion: @escaping () -> Void) {
        switch index {
        case 0, 5:
            DispatchQueue.main.async {
                completion()
            }
        default:
            break
        }
    }
    
    func pickerViewDidSelectAt(row: Int) {
        switch indexOfFirstResponder {
        case 0:
            let text = categories[row].name
            textFromCategoryTF = text
            needUpdateTextFieldWithPickerView?(.category, text)
        case 5:
            let text = listOfWaterRatio[row]
            textFromWaterRatioTF = text
            calculateWaterRatio(row: row)
            needUpdateTextFieldWithPickerView?(.waterRatio, text)
        default:
            break
        }
    }
    
    func didTapChangeResponderButton(type: ToolBarButtonsForKBType) {
        switch type {
        case .down:
            needUpdateFirstResponder?(calculationOfLowerResponder())
        case .up:
            needUpdateFirstResponder?(calculationOfUpperResponder())
        }
    }
    
    
    func getProductInfoViewModel() -> ProductInfoViewModelProtocol {
        ProductInfoViewModel(product: completedProduct)
    }
}

//
//  AddNewProductViewModel.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 09.03.2021.
//



import Foundation

enum IncorrectMessages: String {
    case incorrectTitle = "Что-то не так с названием, проверьте его"
    case incorrectCookingTime = "Нам кажется, или время приготовления выбрано не верно"
    case incorrectCategory = "Пожалуйста, выберите категорию продукта"
    case incorrectProducer = "Производитель продукта, тоже очень важен"
}

protocol AddNewProductViewModelProtocol {
    var codeLabelText: String? { get set }
    var textFromTitleProductTF: String? { get set }
    var textFromCookingTimeTF: String? { get set }
    var textFromWeightTF: String? { get set }
    var textFromProducerTF: String? { get set }
    var categorySelected: Bool { get set }
    var needStirring: Bool { get set }
    var waterRatio: Double { get set }
    var incorrectMessage: String { get }
    var stringForWaterRatio: String { get }
    var selectedCategory: String? { get set}
    var completedProduct: Product? { get }
    var categories: [Category] { get }
    func validation() -> Bool
    func initializeProduct()
    func createProductInCoreData()
    func createProductInFB()
    func getCategories()
    
    init(code: String)
    
}

final class AddNewProductViewModel: AddNewProductViewModelProtocol {
    init(code: String) {
        self.codeLabelText = code
    }
    
    
    // MARK: - Properties
    var completedProduct: Product?
    var selectedCategory: String?
    var codeLabelText: String?
    var textFromTitleProductTF: String?
    var textFromCookingTimeTF: String?
    var textFromProducerTF: String?
    var categorySelected: Bool = false
    var needStirring: Bool = true
    var waterRatio: Double = 1
    var textFromWeightTF: String?
    var incorrectMessage: String = ""
    var categories: [Category] = []
    var stringForWaterRatio: String {
        "🍚 1 : \(Int(waterRatio))💧"
    }
    
    
    // MARK: - Methods
    
    func validation() -> Bool {
        guard categorySelected else {
            incorrectMessage = IncorrectMessages.incorrectCategory.rawValue
            return false }
        guard let titleText = textFromTitleProductTF else {
            incorrectMessage = IncorrectMessages.incorrectTitle.rawValue
            return false }
        guard let producerText = textFromProducerTF else {
            incorrectMessage = IncorrectMessages.incorrectProducer.rawValue
            return false }
        guard let cookingTime = textFromCookingTimeTF else {
            incorrectMessage = IncorrectMessages.incorrectCookingTime.rawValue
            return false }
        guard let intCookingTime = Int(cookingTime) else {
            incorrectMessage = IncorrectMessages.incorrectCookingTime.rawValue
            return false }
        guard titleText.count >= 2 else {
            incorrectMessage = IncorrectMessages.incorrectTitle.rawValue
            return false }
        guard producerText.count >= 2 else {
            incorrectMessage = IncorrectMessages.incorrectProducer.rawValue
            return false }
        guard intCookingTime > 0 else {
            incorrectMessage = IncorrectMessages.incorrectCookingTime.rawValue
            return false }
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
    
    func createProductInCoreData() {
        guard let productCD = completedProduct else { return }
        StorageManager.shared.saveProductCD(code: productCD.code, title: productCD.title,
                                            producer: productCD.producer, category: productCD.category,
                                            weight: productCD.weight, cookingTime: productCD.cookingTime,
                                            intoBoilingWater: productCD.intoBoilingWater,
                                            needStirring: productCD.needStirring,
                                            waterRatio: productCD.waterRatio, date: Date())
    }
    
    func initializeProduct() {
        guard let barcode = codeLabelText else { return }
        guard let title = textFromTitleProductTF else { return }
        guard let producer = textFromProducerTF else { return }
        guard let category = selectedCategory else { return }
        guard let cookingTimeString = textFromCookingTimeTF else { return}
        guard let cookingTimeInt = Int(cookingTimeString) else { return }
        var weightInt: Int?
        if let weightString = textFromWeightTF {
            weightInt = Int(weightString) }
        completedProduct = Product(code: barcode, title: title,
                                   producer: producer, category: category,
                                   weight: weightInt, cookingTime: cookingTimeInt,
                                   intoBoilingWater: true, needStirring: needStirring,
                                   waterRatio: waterRatio)
    }
}

protocol AddNewProductViewControllerDelegate {
    func getSelectedItemFromPopOver(selectedCategory: String)
}




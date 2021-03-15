//
//  CustomTabBarControllerViewModel.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 15.03.2021.
//

import Foundation



protocol CustomTabBarControllerViewModelProtocol: class {
    var alertMessages: String { get }
    var alertTitle: String { get }
    func getProductFromFB(code: String, completionS: @escaping() -> Void, completionB: @escaping() -> Void)
    var product: Product? { get }
    var showAlert: Bool { get set }
    var codeFromBarCodeScanner: String { get set }
    func createProductInCoreData()
}

class CustomTabBarControllerViewModel: CustomTabBarControllerViewModelProtocol {
    var showAlert: Bool = false
    
    var codeFromBarCodeScanner: String = ""
    var product: Product?
    
    func getProductFromFB(code: String, completionS: @escaping() -> Void, completionB: @escaping() -> Void) {
        FirebaseService.shared.fetchProduct(byCode: code) { result in
            switch result {
            case .success(let product):
                if product != nil {
                    self.product = product
                    DispatchQueue.main.async {
                        completionS()
                    }
                }
                else {
                    DispatchQueue.main.async {
                        completionB()
                    }
                }
            case .failure(_): break
            }
        }
    }
    
    
    func createProductInCoreData() {
        guard let productCD = product else { return }
        StorageManager.shared.saveProductCD(code: productCD.code, title: productCD.title,
                                            producer: productCD.producer, category: productCD.category,
                                            weight: productCD.weight, cookingTime: productCD.cookingTime,
                                            intoBoilingWater: productCD.intoBoilingWater,
                                            needStirring: productCD.needStirring,
                                            waterRatio: productCD.waterRatio, date: Date())
    }
    
    var alertTitle: String = "Хьюстон, у нас проблемы"
    var alertMessages: String = "Кажется, данного продукта еще нет в базе, вы можете нам помочь и добавить его вручную"
    
    
}

//
//  CustomTabBarControllerViewModel.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 15.03.2021.
//

import Foundation



protocol CustomTabBarControllerViewModelProtocol: class {
    func getProductFromFB(code: String, completionSuccess: @escaping() -> Void, completionProductNotFound: @escaping() -> Void)
    var product: Product? { get }
    var codeFromBarCodeScanner: String { get set }
    func createProductInCoreData()
}

class CustomTabBarControllerViewModel: CustomTabBarControllerViewModelProtocol {
    
    // MARK: - Properties
    
    var codeFromBarCodeScanner: String = ""
    var product: Product?
    
    
    // MARK: - Methods
    
    func getProductFromFB(code: String, completionSuccess: @escaping() -> Void, completionProductNotFound: @escaping() -> Void) {
        FirebaseService.shared.fetchProduct(byCode: code) { [weak self] result in
            switch result {
            case .success(let product):
                
                if product != nil {
                    self?.product = product
                    DispatchQueue.main.async {
                        completionSuccess()
                    }
                } else {
                    DispatchQueue.main.async {
                        completionProductNotFound()
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
}

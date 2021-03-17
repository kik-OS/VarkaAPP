//
//  CustomTabBarControllerViewModel.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 15.03.2021.
//

import Foundation



protocol CustomTabBarControllerViewModelProtocol: class {
    
    var product: Product? { get }
    var codeFromBarCodeScanner: String { get set }
    func createProductInCoreData()
    func getProductFromFB(code: String, completionSuccess: @escaping() -> Void,
                          completionProductNotFound: @escaping() -> Void)
}

class CustomTabBarControllerViewModel: CustomTabBarControllerViewModelProtocol {
    
    // MARK: - Properties
    
    var codeFromBarCodeScanner: String = ""
    var product: Product?
    
    
    // MARK: - Methods
    
    func getProductFromFB(code: String, completionSuccess: @escaping() -> Void,
                          completionProductNotFound: @escaping() -> Void) {
        
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
    
    
    //Переделать 
    func createProductInCoreData() {
        guard let productCD = product else { return }
        StorageManager.shared.saveProductCD(product: productCD)
    }
}

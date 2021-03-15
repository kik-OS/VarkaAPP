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
    func getProductFromFB(code: String)
    var product: Product? { get }
    var showAlert: Bool { get set }
}

class CustomTabBarControllerViewModel: CustomTabBarControllerViewModelProtocol {
    var showAlert: Bool = false
    
    
    var product: Product?
    
    func getProductFromFB(code: String) {
        FirebaseService.shared.fetchProduct(byCode: code) { result in
            switch result {
            case .success(let prod):
                
                print(prod?.code)
            case .failure(_):
                print("Ошибка")
            }
        }
    }
    
   
    
    var alertTitle: String = "Хьюстон, у нас проблемы"
    var alertMessages: String = "Кажется, данного продукта еще нет в базе, вы можете нам помочь и добавить его вручную"
    
    
}

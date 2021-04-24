//
//  CustomTabBarViewModel.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 15.03.2021.
//

import Foundation

protocol CustomTabBarViewModelProtocol: class {
    /// Вызывается в случае успешного получения продукта из базы. В параметр передаётся ProductInfoViewModel с полученным из базы продуктом.
    var productDidReceive: ((_ productInfoViewModel: ProductInfoViewModelProtocol) -> Void)? { get set }
    /// Вызывается для предложения добавить товар. В параметр передаётся бар-код, полученный от сканера.
    var addingNewProductOffer: ((_ code: String) -> Void)? { get set }
    /// Вызывается при каждом шаге таймера.
    var timerDidStep: ((_ time: String) -> Void)? { get set }
    var constantForMiddleButton: Float { get }
    var sizeForMiddleButton: Float { get }
    func findProduct(byCode code: String)
    func getProductInfoViewModel(product: Product?) -> ProductInfoViewModelProtocol
    func getRecentProductViewModel() -> RecentProductViewModelProtocol
    func getAddingNewProductViewModel(withCode code: String) -> AddingNewProductViewModelProtocol
    func getTimerViewModel() -> TimerViewModelProtocol
}

final class CustomTabBarViewModel: CustomTabBarViewModelProtocol {
    
    
    // MARK: - Properties
    
    var productDidReceive: ((_ productInfoViewModel: ProductInfoViewModelProtocol) -> Void)?
    var addingNewProductOffer: ((_ code: String) -> Void)?
    var timerDidStep: ((_ time: String) -> Void)?
    var constantForMiddleButton: Float {
        DeviceManager.checkSquareScreen() ? 0 : 10
    }
    var sizeForMiddleButton: Float {
        DeviceManager.checkSquareScreen() ? 68 : 72
    }
    
    private let firebaseService: FirebaseServiceProtocol = FirebaseService.shared
    
    // MARK: - Initializers
    
    init() {
        TimerManager.shared.barDelegate = self
    }
    
    // MARK: - Public methods
    
    func findProduct(byCode code: String) {
        firebaseService.fetchProduct(byCode: code) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let product):
                self.productDidReceive?(self.getProductInfoViewModel(product: product))
                self.createProductInCoreData(product: product)
            case .failure(let error):
                print(error.localizedDescription)
                self.addingNewProductOffer?(code)
            }
        }
    }
    
    func getProductInfoViewModel(product: Product?) -> ProductInfoViewModelProtocol {
        ProductInfoViewModel(product: product)
    }
    
    func getRecentProductViewModel() -> RecentProductViewModelProtocol {
        RecentProductViewModel()
    }
    
    func getAddingNewProductViewModel(withCode code: String) -> AddingNewProductViewModelProtocol {
        AddingNewProductViewModel(code: code)
    }
    
    func getTimerViewModel() -> TimerViewModelProtocol {
        TimerViewModel()
    }
    
    // MARK: - Private methods
    
    private func createProductInCoreData(product: Product) {
        StorageManager.shared.saveProductCD(product: product)
    }
}

extension CustomTabBarViewModel: TimerManagerBarDelegate {
    
    func timerDidStep(time: String) {
        timerDidStep?(time)
    }
}

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
    /// Вызывается при старте таймера из всплывающего окна.
    var timerDidStart: ((_ time: String) -> Void)? { get set }
    
    func findProduct(byCode code: String)
    func getProductInfoViewModel(product: Product?) -> ProductInfoViewModelProtocol
    func getRecentProductCollectionViewViewModel() -> RecentProductCollectionViewViewModelProtocol
    func getAddingNewProductViewModel(withCode code: String) -> AddingNewProductViewModelProtocol
    func getTimerViewModel() -> TimerViewModelProtocol
}

final class CustomTabBarViewModel: CustomTabBarViewModelProtocol {
    
    // MARK: - Properties
    
    var productDidReceive: ((_ productInfoViewModel: ProductInfoViewModelProtocol) -> Void)?
    var addingNewProductOffer: ((_ code: String) -> Void)?
    var timerDidStart: ((_ time: String) -> Void)?
    
    /// Время таймера в секундах.
    private var timerTime = 0
    
    private var stringTimerTime: String {
        let minutes = timerTime / 60
        let seconds = timerTime - (minutes * 60)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumIntegerDigits = 2
        guard let stringSeconds = numberFormatter.string(for: seconds) else { return "" }
        
        return timerTime > 0
            ? "Осталось: \(minutes):\(stringSeconds)"
            : "Блюдо готово!!!"
    }
    
    private let firebaseService: FirebaseServiceProtocol = FirebaseService.shared
    
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
    
    func getRecentProductCollectionViewViewModel() -> RecentProductCollectionViewViewModelProtocol {
        RecentProductCollectionViewViewModel()
    }
    
    func getAddingNewProductViewModel(withCode code: String) -> AddingNewProductViewModelProtocol {
        AddingNewProductViewModel(code: code)
    }
    
    func getTimerViewModel() -> TimerViewModelProtocol {
        TimerViewModel(delegate: self)
    }
    
    // MARK: - Private methods
    
    private func createProductInCoreData(product: Product) {
        StorageManager.shared.saveProductCD(product: product)
    }
}

extension CustomTabBarViewModel: TimerViewModelDelegate {
    
    func startTimerOn(minutes: Int) {
        timerTime = minutes * 60
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimer),
                             userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer(sender: Timer) {
        guard timerTime >= 0 else {
            sender.invalidate()
            return
        }
        timerDidStart?(stringTimerTime)
        timerTime -= 1
    }
}

//
//  CustomTabBarController.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 05.03.2021.
//

import UIKit
import BarcodeScanner

final class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    // MARK: - Properties
    
    var viewModel: CustomTabBarViewModelProtocol
    private let middleButton = UIButton.setupMiddleButtonTabBar()
    
    // MARK: - Initializers
    
    required init?(coder: NSCoder) {
        viewModel = CustomTabBarViewModel()
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMiddleButton()
        setupTabBarItems()
        setupViewModelBindings()
        delegate = self
        StorageManager.shared.saveProductCD(product: Product(code: "21121", title: "Hhbhsx", producer: "dcdcd", category: "Макароны", weight: 20, cookingTime: 40, intoBoilingWater: true, needStirring: true, waterRatio: 3))
        StorageManager.shared.saveProductCD(product: Product(code: "33321", title: "Hhbhsx", producer: "dcdcd", category: "Вареники", weight: 20, cookingTime: 40, intoBoilingWater: true, needStirring: true, waterRatio: 3))
    }
    
    override func viewDidLayoutSubviews() {
        tabBar.itemPositioning = .centered
        tabBar.itemSpacing = UIScreen.main.bounds.width / 2.5
        middleButton.layer.cornerRadius = middleButton.frame.width / 2
    }
    
    
    // MARK: - Actions
    
    @objc private func centerButtonAction(sender: UIButton) {
        sender.animationForMiddleButton()
        let barCodeScannerVC = CustomBarcodeScannerViewController(delegate: self)
        barCodeScannerVC.modalPresentationStyle = .fullScreen
        present(barCodeScannerVC, animated: true, completion: nil)
    }
    
    @IBAction private func timerBarButtonTapped(_ sender: UIBarButtonItem) {
        let timerViewModel = viewModel.getTimerViewModel()
        let timerVC = TimerViewController(nibName: nil, bundle: nil, viewModel: timerViewModel)
        timerVC.modalPresentationStyle = .overCurrentContext
        present(timerVC, animated: true)
    }
    
    // MARK: - Private methods
    
    private func setupTabBarItems() {
        tabBar.tintColor = VarkaColors.mainColor
        let productInfoViewModel = viewModel.getProductInfoViewModel(product: nil)
        let productInfoVC = ProductInfoViewController(nibName: nil,
                                                      bundle: nil,
                                                      viewModel: productInfoViewModel)
        productInfoVC.tabBarItem.title = Inscriptions.tabBarItemLeftTitle
        productInfoVC.tabBarItem.image = UIImage(named: ImageTitles.tabBarItemLeft)
        let recentProductsVC = RecentProductsViewController()
        recentProductsVC.viewModel = viewModel.getRecentProductViewModel()
        recentProductsVC.tabBarItem.title = Inscriptions.tabBarItemRightTitle
        recentProductsVC.tabBarItem.image = UIImage(named: ImageTitles.tabBarItemRight)
        viewControllers = [productInfoVC, recentProductsVC]
    }
    
    private func setupMiddleButton() {
        middleButton.addTarget(self, action: #selector(centerButtonAction), for: .touchUpInside)
        view.addSubview(middleButton)
        view.layoutIfNeeded()
        NSLayoutConstraint.activate([
            middleButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
            middleButton.centerYAnchor.constraint(equalTo: tabBar.topAnchor, constant: CGFloat(viewModel.constantForMiddleButton)),
            middleButton.widthAnchor.constraint(equalToConstant: CGFloat(viewModel.sizeForMiddleButton)),
            middleButton.heightAnchor.constraint(equalToConstant: CGFloat(viewModel.sizeForMiddleButton))
        ])
    }
    
    private func setupViewModelBindings() {
        viewModel.productDidReceive = { [unowned self] productInfoViewModel in
            guard let productInfoVC = viewControllers?.first as? ProductInfoViewController else { return }
            productInfoVC.viewModel = productInfoViewModel
            selectedViewController = viewControllers?.first
        }
        
        viewModel.addingNewProductOffer = { [unowned self] code in
            let alertController = offerToAddingProductAlertController {
                guard let addNewProductVC = self.storyboard?.instantiateViewController(
                    identifier: Inscriptions.addNewProductVCStoryBoardID
                ) as? AddingNewProductViewController else { return }
                addNewProductVC.viewModel = self.viewModel.getAddingNewProductViewModel(withCode: code)
                self.present(addNewProductVC, animated: true)
            }
            self.present(alertController, animated: true)
        }
        viewModel.timerDidStep = { [unowned self] time in
            title = time
        }
    }
    
    private func offerToAddingProductAlertController(okActionCompletion: @escaping () -> Void) -> UIAlertController {
        let alertController = UIAlertController(title: Inscriptions.barCodeAlertTitle,
                                                message: Inscriptions.barCodeAlertMessage,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: Inscriptions.barCodeAlertButtonOkTitle,
                                     style: .default) { _ in okActionCompletion() }
        let cancelAction = UIAlertAction(title: Inscriptions.barCodeAlertButtonCancelTitle,
                                         style: .default) { _ in }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        return alertController
    }
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            return TabBarTransition(viewControllers: tabBarController.viewControllers)
        }
}

// MARK: - Extensions

extension CustomTabBarController: BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate {
    
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {        
        viewModel.findProduct(byCode: code)
        dismiss(animated: true)
    }
    
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        print(error.localizedDescription)
    }
    
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        dismiss(animated: true)
    }
}

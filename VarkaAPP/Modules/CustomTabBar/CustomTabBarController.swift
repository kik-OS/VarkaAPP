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
    
    private var viewModel: CustomTabBarViewModelProtocol
    
    // MARK: - Initializers
    
    required init?(coder: NSCoder) {
        viewModel = CustomTabBarViewModel()
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self // НУЖЕН?
        setupMiddleButton()
        setupTabBarItems()
        setupViewModelBindings()
    }
    
    // Изменение расстояния между tab bar items
    override func viewDidLayoutSubviews() {
        tabBar.itemPositioning = .centered
        tabBar.itemSpacing = UIScreen.main.bounds.width / 2.5
    }
    
    // MARK: - Actions
    
    @objc private func centerButtonAction(sender: UIButton) {
        sender.animationForCentralButton()
        let barCodeScannerVC = BarcodeScannerViewController()
        barCodeScannerVC.codeDelegate = self
        barCodeScannerVC.errorDelegate = self
        barCodeScannerVC.dismissalDelegate = self
        barCodeScannerVC.modalPresentationStyle = .fullScreen
        barCodeScannerVC.messageViewController.regularTintColor = .systemIndigo
        barCodeScannerVC.messageViewController.textLabel.textColor = .systemIndigo
        barCodeScannerVC.headerViewController.closeButton.tintColor = .systemIndigo
        present(barCodeScannerVC, animated: true, completion: nil)
    }
    
    // MARK: - Private methods
    
    private func setupTabBarItems() {
        tabBar.tintColor = .systemIndigo
        
        let productInfoViewModel = viewModel.getProductInfoViewModel(product: nil)
        let productInfoVC = ProductInfoViewController(nibName: nil,
                                                      bundle: nil,
                                                      viewModel: productInfoViewModel)
        productInfoVC.tabBarItem.title = Inscriptions.tabBarItemLeftTitle
        productInfoVC.tabBarItem.image = UIImage(named: ImageTitles.tabBarItemLeft)
        
        let recentProductsVC = RecentProductsViewController()
        let recentProductCollectionViewViewModel = viewModel.getRecentProductCollectionViewViewModel()
        recentProductsVC.recentProductCollectionView.viewModel = recentProductCollectionViewViewModel
        recentProductsVC.tabBarItem.title = Inscriptions.tabBarItemRightTitle
        recentProductsVC.tabBarItem.image = UIImage(named: ImageTitles.tabBarItemRight)
        
        viewControllers = [productInfoVC, recentProductsVC]
    }
    
    private func setupMiddleButton() {
        let middleButton = UIButton()
        middleButton.backgroundColor = .white
        middleButton.layer.borderColor = UIColor.white.cgColor
        middleButton.layer.borderWidth = 1
        middleButton.layer.cornerRadius = 34
        middleButton.clipsToBounds = true
        middleButton.tintColor = .systemIndigo
        middleButton.animationForCentralButton()
        middleButton.addTarget(self, action: #selector(centerButtonAction), for: .touchUpInside)
        middleButton.translatesAutoresizingMaskIntoConstraints = false
        middleButton.setImage(UIImage(systemName: ImageTitles.tabBarMiddleButton), for: .normal)
        middleButton.setPreferredSymbolConfiguration(
            UIImage.SymbolConfiguration(pointSize: 35, weight: .thin), forImageIn: .normal
        )
        
        view.addSubview(middleButton)
        view.layoutIfNeeded()
        
        NSLayoutConstraint.activate([
            middleButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
            middleButton.centerYAnchor.constraint(equalTo: tabBar.topAnchor),
            middleButton.widthAnchor.constraint(equalToConstant: 68),
            middleButton.heightAnchor.constraint(equalToConstant: 68)
        ])
    }
    
    private func setupViewModelBindings() {
        viewModel.productDidReceive = { [unowned self] productInfoViewModel in
            guard let productInfoVC = viewControllers?.first as? ProductInfoViewController else { return }
            productInfoVC.viewModel = productInfoViewModel
            selectedViewController = viewControllers?.first
        }
        
        viewModel.addingNewProductOffer = { [unowned self] code in
            let alertController = productAddingOfferAlertController {
                guard let addNewProductVC = self.storyboard?.instantiateViewController(
                        identifier: Inscriptions.addNewProductVCStoryBoardID
                ) as? AddingNewProductViewController else { return }
                addNewProductVC.viewModel = self.viewModel.getAddingNewProductViewModel(withCode: code)
                self.present(addNewProductVC, animated: true)
            }
            
            self.present(alertController, animated: true)
        }
    }
    
    private func productAddingOfferAlertController(okActionCompletion: @escaping () -> Void) -> UIAlertController {
        let alertController = UIAlertController(title: Inscriptions.barCodeAlertTitle,
                                                message: Inscriptions.barCodeAlertMessage,
                                                preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: Inscriptions.barCodeAlertButtonOkTitle,
                                     style: .default) { _ in
            okActionCompletion()
        }
        let cancelAction = UIAlertAction(title: Inscriptions.barCodeAlertButtonCancelTitle,
                                         style: .cancel) { _ in }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        return alertController
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

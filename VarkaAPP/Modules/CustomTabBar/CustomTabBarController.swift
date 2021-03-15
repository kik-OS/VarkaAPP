//
//  CustomTabBarController.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 05.03.2021.
//

import UIKit
import BarcodeScanner

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var viewModel: CustomTabBarControllerViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CustomTabBarControllerViewModel()
        delegate = self
        setupMiddleButton()
        setupTabs()
    }
    
    
    // MARK: - Private methods
    
    private func setupTabs() {
        let productInfoViewModel = ProductInfoViewModel(product: nil)
        let productInfoVC = ProductInfoViewController(nibName: nil,
                                                      bundle: nil,
                                                      viewModel: productInfoViewModel)
        
        let recentProductsVC = RecentProductsViewController()
        productInfoVC.tabBarItem.title = "Как варить"
        productInfoVC.tabBarItem.image = UIImage(named: "pot.png")
        tabBar.tintColor = .systemIndigo
        
        recentProductsVC.tabBarItem.title = "Недавние продукты"
        recentProductsVC.tabBarItem.image = UIImage(named: "box.png")
        viewControllers = [productInfoVC, recentProductsVC]
    }
    
    
    private func setupMiddleButton() {
        
        let middleButton = UIButton(frame: CGRect(x: (view.bounds.width / 2) - 30,
                                                  y: -30,
                                                  width: 60,
                                                  height: 60))
        
        middleButton.setImage(UIImage(systemName: "barcode.viewfinder"), for: .normal)
        middleButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 35,
                                                                                 weight: .thin),
                                                     forImageIn: .normal)
        middleButton.backgroundColor = .white
        middleButton.layer.borderColor = UIColor.white.cgColor
        middleButton.layer.borderWidth = 1
        middleButton.layer.cornerRadius = 0.5 * middleButton.bounds.size.width
        middleButton.clipsToBounds = true
        middleButton.tintColor = .systemIndigo
        middleButton.animationForCentralButton()
        middleButton.addTarget(self, action: #selector(centerButtonAction), for: .touchUpInside)
        
        tabBar.addSubview(middleButton)
        view.layoutIfNeeded()
    }
    
    @objc func centerButtonAction(sender: UIButton) {
        sender.animationForCentralButton()
        let barCodeScannerVC = BarcodeScannerViewController()
        barCodeScannerVC.codeDelegate = self
        barCodeScannerVC.errorDelegate = self
        barCodeScannerVC.dismissalDelegate = self
        //        barCodeScannerVC.modalPresentationStyle = .fullScreen
        barCodeScannerVC.messageViewController.regularTintColor = .systemIndigo
        barCodeScannerVC.messageViewController.textLabel.textColor = .systemIndigo
        barCodeScannerVC.headerViewController.closeButton.tintColor = .systemIndigo
        present(barCodeScannerVC, animated: true, completion: nil)
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: viewModel.alertTitle, message: viewModel.alertMessages, preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "Добавить", style: .default) { _ in
            //
        }
        let cancelAction = UIAlertAction(title: "Нет, не хочу", style: .default) { _ in
            //
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    func showProductInfoVC() {
        guard let productInfoVC = tabBarController?.viewControllers?.first as? ProductInfoViewController else { return }
        productInfoVC.viewModel = ProductInfoViewModel(product: viewModel.product)
        present(productInfoVC, animated: true)
    }
    
}

// MARK: - Extensions

extension CustomTabBarController: BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate {
    
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        viewModel.getProductFromFB(code: code)
//        viewModel.showAlert ? showAlert() : showProductInfoVC()
//        viewModel.showAlert = false
//        dismiss(animated: true)
        
        
        
        
    }
    
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        print(error.localizedDescription)
    }
    
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        dismiss(animated: true)
    }
}





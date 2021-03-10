//
//  CustomTabBarController.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 05.03.2021.
//

import UIKit
import BarcodeScanner

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    let firebaseService: FirebaseServiceProtocol = FirebaseService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        setupMiddleButton()
        setupTabs()
        
    }
    
    func setupMiddleButton() {
        
        let middleBtn = UIButton(frame: CGRect(x: (view.bounds.width / 2) - 30,
                                               y: -30,
                                               width: 60,
                                               height: 60))
        
        middleBtn.setImage(UIImage(systemName: "barcode.viewfinder"), for: .normal)
        middleBtn.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 35,
                                                                              weight: .thin),
                                                                              forImageIn: .normal)
        
        middleBtn.backgroundColor = .white
        middleBtn.layer.borderColor = UIColor.white.cgColor
        middleBtn.layer.borderWidth = 1
        middleBtn.layer.cornerRadius = 0.5 * middleBtn.bounds.size.width
        middleBtn.clipsToBounds = true
        middleBtn.tintColor = .systemIndigo
        
        middleBtn.animationForCentralButton()
        middleBtn.addTarget(self, action: #selector(centerButtonAction), for: .touchUpInside)
        
        tabBar.addSubview(middleBtn)
        view.layoutIfNeeded()
    }
    
    
    @objc func centerButtonAction(sender: UIButton) {
        sender.animationForCentralButton()
        let barCodeScanerVC = BarcodeScannerViewController()
        barCodeScanerVC.codeDelegate = self
        barCodeScanerVC.errorDelegate = self
        barCodeScanerVC.dismissalDelegate = self
        barCodeScanerVC.modalPresentationStyle = .fullScreen
        present(barCodeScanerVC, animated: true, completion: nil)
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
}


extension CustomTabBarController: BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate {
    
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        
//        firebaseService.fetchProduct(byCode: code) { [weak self] result in
//            switch result {
//            case .success(let product):
//
//                if let product = product {
//                    let productInfoViewModel = ProductInfoViewModel(product: product)
//                    guard let productInfoVC = self?.viewControllers?.first as? ProductInfoViewController else { return }
//                    productInfoVC.viewModel = productInfoViewModel
//                }
//            case .failure:
//                break
//            }
//        }
        
        dismiss(animated: true)
    }
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        print(error.localizedDescription)
    }
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        dismiss(animated: true)
    }
}





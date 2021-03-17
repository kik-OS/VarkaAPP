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
        setupTabBarItems()
    }
    
    //изменение расстояния между tab bar items
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tabBar.itemPositioning = .centered
        tabBar.itemSpacing = UIScreen.main.bounds.width / 2.5
    }
    
    // MARK: - Private methods
    
    private func setupTabBarItems() {
        let productInfoViewModel = ProductInfoViewModel(product: nil)
        let productInfoVC = ProductInfoViewController(nibName: nil,
                                                      bundle: nil,
                                                      viewModel: productInfoViewModel)
        
        let recentProductsVC = RecentProductsViewController()
        productInfoVC.tabBarItem.title = Inscriptions.tabBarItemLeftTitle
        productInfoVC.tabBarItem.image = UIImage(named: ImageTitles.tabBarItemLeft)
        tabBar.tintColor = .systemIndigo
        
        recentProductsVC.tabBarItem.title = Inscriptions.tabBarItemRightTitle
        recentProductsVC.tabBarItem.image = UIImage(named: ImageTitles.tabBarItemRight)
        recentProductsVC.recentProductCollectionView.viewModel = RecentProductCollectionViewViewModel()
        viewControllers = [productInfoVC, recentProductsVC]
    }
    
    
    private func setupMiddleButton() {
        
//        let middleButton = UIButton(frame: CGRect(x: (view.bounds.width / 2) - 30,
//                                                  y: -30,
//                                                  width: 60,
//                                                  height: 60))
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
        middleButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 35,
                                                                                 weight: .thin),
                                                                                 forImageIn: .normal)
        
        view.addSubview(middleButton)
        view.layoutIfNeeded()
        
        middleButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor).isActive = true
        middleButton.centerYAnchor.constraint(equalTo: tabBar.topAnchor).isActive = true
        middleButton.widthAnchor.constraint(equalToConstant: 68).isActive = true
        middleButton.heightAnchor.constraint(equalToConstant: 68).isActive = true
         
    }
    
    @objc func centerButtonAction(sender: UIButton) {
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
    
    private func showAlert() {
        let alert = UIAlertController(title: Inscriptions.barCodeAlertTitle, message: Inscriptions.barCodeAlertMessage, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: Inscriptions.barCodeAlertButtonOkTitle, style: .destructive) { [weak self] _ in
            //Действие при нажатии на ok
            guard let self = self else { return }
            //Перенести инициализацию в модель
            guard let addNewProductVC = self.storyboard?.instantiateViewController(identifier: Inscriptions.addNewProductVCStoryBoardID) as? AddNewProductViewController else { return }
            addNewProductVC.viewModel = AddNewProductViewModel(code: self.viewModel.codeFromBarCodeScanner)
            self.present(addNewProductVC, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: Inscriptions.barCodeAlertButtonCancelTitle, style: .default) { _ in
            //действие при нажатии на cancel
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    private func showProductInfoVC() {
        guard let productInfoVC = viewControllers?.first as? ProductInfoViewController else { return }
        productInfoVC.viewModel = ProductInfoViewModel(product: viewModel.product)
        viewModel.createProductInCoreData()
//        self.selectedIndex = 0
        selectedViewController = viewControllers?.first
    }
    
   
}


// MARK: - Extensions

extension CustomTabBarController: BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate {
    
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        viewModel.codeFromBarCodeScanner = code
        
        viewModel.getProductFromFB(code: code) { [weak self] in
            self?.showProductInfoVC()
        } completionProductNotFound: { [weak self] in
            self?.showAlert()
        }
        self.dismiss(animated: true)
    }
    
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        print(error.localizedDescription)
    }
    
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        dismiss(animated: true)
        
    }
}





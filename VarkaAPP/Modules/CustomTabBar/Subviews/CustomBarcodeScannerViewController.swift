//
//  CustomBarcodeScannerViewController.swift
//  VarkaAPP
//
//  Created by Evgeny Novgorodov on 18.03.2021.
//

import BarcodeScanner

final class CustomBarcodeScannerViewController: BarcodeScannerViewController {
    
    init(delegate: CustomTabBarController) {
        super.init(nibName: nil, bundle: nil)
        codeDelegate = delegate
        errorDelegate = delegate
        dismissalDelegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageViewController.regularTintColor = .black
        messageViewController.textLabel.textColor = .black
        headerViewController.closeButton.tintColor = VarkaColors.mainColor
    }
}

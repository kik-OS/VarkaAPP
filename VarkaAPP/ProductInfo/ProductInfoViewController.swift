//
//  ProductInfoViewController.swift
//  VarkaAPP
//
//  Created by Evgeny Novgorodov on 06.03.2021.
//

import UIKit
import Firebase

final class ProductInfoViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var barcodeLabel: UILabel!
    @IBOutlet weak var producerLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var cookingTimeLabel: UILabel!
    @IBOutlet weak var intoBoilingWaterLabel: UILabel!
    @IBOutlet weak var needStirringLabel: UILabel!
    
    // MARK: - Properties
    
    private var viewModel: ProductInfoViewModelProtocol
    
    // MARK: - Initializers
    
    init(nibName nibNameOrNil: String?,
         bundle nibBundleOrNil: Bundle?,
         viewModel: ProductInfoViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.product.value = Product.getProducts().first!
        
        setupViewModelBindings()
    }
    
    // MARK: - Private methods
    
    private func setupViewModelBindings() {
        viewModel.product.bind { [unowned self] product in
            self.titleLabel.text = product?.title
            self.barcodeLabel.text = product?.code
            self.producerLabel.text = product?.producer
            self.categoryLabel.text = product?.category
            self.weightLabel.text = viewModel.weight
            self.cookingTimeLabel.text = viewModel.cookingTime
            self.intoBoilingWaterLabel.text = viewModel.intoBoilingWater
            self.needStirringLabel.text = viewModel.needStirring
        }
    }
}

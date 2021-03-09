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
    
    @IBOutlet weak var productStackView: UIStackView!
    @IBOutlet weak var infoLabel: UILabel!
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
            guard !viewModel.isHiddenProductStackView else { return }
            
            titleLabel.text = product?.title
            barcodeLabel.text = product?.code
            producerLabel.text = product?.producer
            categoryLabel.text = product?.category
            weightLabel.text = viewModel.weight
            cookingTimeLabel.text = viewModel.cookingTime
            intoBoilingWaterLabel.text = viewModel.intoBoilingWater
            needStirringLabel.text = viewModel.needStirring
            productStackView.isHidden = false
            infoLabel.isHidden = true
        }
    }
}
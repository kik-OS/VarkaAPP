//
//  ProductInfoViewController.swift
//  VarkaAPP
//
//  Created by Evgeny Novgorodov on 06.03.2021.
//

import UIKit

final class ProductInfoViewController: UIViewController {
    
    // MARK: - Outlets
    
    
    @IBOutlet private var productInfoStackView: [UIStackView]!
    @IBOutlet private weak var instructionImage: UIImageView!
    @IBOutlet private weak var productImage: UIImageView!
    @IBOutlet private weak var infoStackView: UIStackView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var barcodeLabel: UILabel!
    @IBOutlet private weak var producerLabel: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var weightLabel: UILabel!
    @IBOutlet private weak var cookingTimeLabel: UILabel!
    @IBOutlet private weak var firstStepLabel: UILabel!
    @IBOutlet private weak var secondStepLabel: UILabel!
    @IBOutlet private weak var thirdStepLabel: UILabel!
    @IBOutlet private weak var fourthStepLabel: UILabel!
    @IBOutlet weak var timerButton: UIButton!
    
    
    // MARK: - Properties
    
    var viewModel: ProductInfoViewModelProtocol {
        didSet {
            setupViewModelBindings()
        }
    }
    
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
        setupNavigationBar()
        view.backgroundColor = VarkaColors.mainColor
        setupViewModelBindings()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        productImage.layer.shadowRadius = 5
        productImage.layer.shadowOpacity = 0.2
        productImage.layer.shadowOffset = CGSize(width: 5, height: 8)
        productImage.clipsToBounds = false
        timerButton.layer.borderWidth = 1
        timerButton.layer.borderColor = VarkaColors.mainColor.cgColor
    }
    
    // MARK: - Actions
    
    @IBAction private func setTimerButtonTapped() {
        let timerViewModel = viewModel.getTimerViewModel()
        let timerVC = TimerViewController(nibName: nil, bundle: nil, viewModel: timerViewModel)
        timerVC.modalPresentationStyle = .overCurrentContext
        
        Notifications.shared.checkNotificationSettings { [weak self] in
            let alert = Notifications.notificationsAreNotAvailableAlert()
            self?.present(alert, animated: true)
        }
        present(timerVC, animated: true)
        
    }
    
    // MARK: - Private methods
    
   private func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    private func setupViewModelBindings() {
        viewModel.product.bind { [unowned self] product in
            guard !viewModel.isHiddenProductStackView else { return }
            infoStackView.isHidden = true
            productInfoStackView.forEach {$0.isHidden = false}
            instructionImage.isHidden = false
            productImage.image = UIImage(named: viewModel.productImage)
            titleLabel.text = product?.title
            barcodeLabel.text = product?.code
            producerLabel.text = product?.producer
            categoryLabel.text = product?.category
            weightLabel.text = viewModel.weight
            cookingTimeLabel.text = viewModel.cookingTime
            firstStepLabel.text = viewModel.firstStep
            secondStepLabel.text = viewModel.secondStep
            thirdStepLabel.text = viewModel.thirdStep
        }
    }
    
    @IBAction func unwind(segue: UIStoryboardSegue) {}
}

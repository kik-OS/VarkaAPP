//
//  ProductInfoViewController.swift
//  VarkaAPP
//
//  Created by Evgeny Novgorodov on 06.03.2021.
//

import UIKit

final class ProductInfoViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var productStackView: UIStackView!
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var barcodeLabel: UILabel!
    @IBOutlet private weak var producerLabel: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var weightLabel: UILabel!
    @IBOutlet private weak var cookingTimeLabel: UILabel!
    @IBOutlet private weak var intoBoilingWaterLabel: UILabel!
    @IBOutlet private weak var needStirringLabel: UILabel!
    
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
        Notifications.shared.showTimerNotification(throughMinutes: 1/60)
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
    
    @IBAction func unwind(segue: UIStoryboardSegue) {}
    
}

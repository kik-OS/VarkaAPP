//
//  ProductInfoViewController.swift
//  VarkaAPP
//
//  Created by Evgeny Novgorodov on 06.03.2021.
//

import UIKit

final class ProductInfoViewController: UIViewController {
    
    // MARK: - Outlets
    
    
    @IBOutlet private weak var instructionCollectionView: UICollectionView!
    @IBOutlet private weak var productImage: UIImageView!
    @IBOutlet private weak var infoStackView: UIStackView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var barcodeLabel: UILabel!
    @IBOutlet private weak var producerLabel: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var weightLabel: UILabel!
    @IBOutlet private weak var cookingTimeLabel: UILabel!
    @IBOutlet private var productInfoStackView: [UIStackView]!
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
        setupCollectionView()
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
            instructionCollectionView.isHidden = false
            productInfoStackView.forEach {$0.isHidden = false}
            productImage.image = UIImage(named: viewModel.productImage)
            titleLabel.text = product?.title
            barcodeLabel.text = product?.code
            producerLabel.text = product?.producer
            categoryLabel.text = product?.category
            weightLabel.text = viewModel.weight
            cookingTimeLabel.text = viewModel.cookingTime
            //            firstStepLabel.text = viewModel.firstStep
            //            secondStepLabel.text = viewModel.secondStep
            //            thirdStepLabel.text = viewModel.thirdStep
        }
    }
    
    private func setupCollectionView() {
        instructionCollectionView.register(UINib(nibName: Inscriptions.productInfoCollectionViewReuseID, bundle: nil), forCellWithReuseIdentifier: Inscriptions.productInfoCollectionViewReuseID)
        instructionCollectionView.backgroundColor = .clear
        instructionCollectionView.showsHorizontalScrollIndicator = false
    }
    
    @IBAction func unwind(segue: UIStoryboardSegue) {}
}


// MARK: - Extension

extension ProductInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: instructionCollectionView.frame.width * 0.9, height: instructionCollectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = instructionCollectionView.dequeueReusableCell(withReuseIdentifier: Inscriptions.productInfoCollectionViewReuseID, for: indexPath) as? ProductInfoCollectionViewCell
        
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        CGFloat(10)
    }
    
}

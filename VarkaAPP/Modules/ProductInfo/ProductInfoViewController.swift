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
    @IBOutlet private weak var viewWithContent: UIView!
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
        setupViewModelBindings()
        setupCollectionView()
        addVerticalGradientLayer(topColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), bottomColor: #colorLiteral(red: 0.8979474902, green: 0.9020553231, blue: 0.8977640867, alpha: 1))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layersConfigure()
        instructionCollectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        timerButton.pulsate()
        instructionCollectionView.shakeView()
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
        timerButton.layer.removeAllAnimations()
        present(timerVC, animated: true)
    }
    
    // MARK: - Private methods
    
    private func addVerticalGradientLayer(topColor: UIColor, bottomColor: UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [topColor.cgColor, bottomColor.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        view.layer.insertSublayer(gradient, at: 0)
    }
    
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
        }
    }
    
    private func setupCollectionView() {
        instructionCollectionView.register(UINib(nibName: Inscriptions.productInfoCollectionViewReuseID, bundle: nil),
                                           forCellWithReuseIdentifier: Inscriptions.productInfoCollectionViewReuseID)
        instructionCollectionView.backgroundColor = .clear
        instructionCollectionView.showsHorizontalScrollIndicator = false
    }
    
    private func layersConfigure() {
        timerButton.layer.cornerRadius = timerButton.frame.height / 2
        timerButton.layer.shadowRadius = 5
        timerButton.layer.shadowOpacity = 0.2
        timerButton.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        timerButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        viewWithContent.layer.shadowRadius = 5
        viewWithContent.layer.shadowOpacity = 0.2
        viewWithContent.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        viewWithContent.layer.shadowOffset = CGSize(width: 0, height: 0)
        viewWithContent.clipsToBounds = false
        productImage.layer.shadowRadius = 5
        productImage.layer.shadowOpacity = 0.2
        productImage.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        productImage.layer.shadowOffset = CGSize(width: 0, height: 0)
        productImage.clipsToBounds = false
        instructionCollectionView.clipsToBounds = false
    }
    
    @IBAction func unwind(segue: UIStoryboardSegue) {}
}


// MARK: - Extension

extension ProductInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        7
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.width - 40 , height: instructionCollectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = instructionCollectionView.dequeueReusableCell(withReuseIdentifier: Inscriptions.productInfoCollectionViewReuseID,
                                                                 for: indexPath) as? ProductInfoCollectionViewCell
        cell?.viewModel = viewModel.cellViewModel(at: indexPath)
        
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        CGFloat(10)
    }
    
}

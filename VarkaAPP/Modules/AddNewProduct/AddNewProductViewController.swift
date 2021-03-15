//
//  AddNewProductViewController.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 09.03.2021.
//

import UIKit

class AddNewProductViewController: UIViewController {
    
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var titleProductTF: UITextField!
    @IBOutlet weak var cookingTimeTF: UITextField!
    @IBOutlet weak var producerTF: UITextField!
    @IBOutlet weak var weightTF: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var waterRatioLabel: UILabel!
    @IBOutlet weak var stepperRatio: UIStepper!
    
    
    
    // MARK: - Properties
    
    private var viewModel: AddNewProductViewModelProtocol!
    
    
    // MARK: - Actions
    
    @IBAction func weightProductEditingChanged() {
        viewModel.textFromWeightTF = weightTF.text
    }
    @IBAction func stepperRatioTapped() {
        viewModel.waterRatio = stepperRatio.value
        waterRatioLabel.text = viewModel.stringForWaterRatio
    }
    @IBAction func needStirringSwitch(_ sender: UISwitch) {
        viewModel.needStirring = sender.isOn
    }
    
    @IBAction func titleProductEditingChanged() {
        viewModel.textFromTitleProductTF = titleProductTF.text
    }
    @IBAction func cookingTimeEditingChanged() {
        viewModel.textFromCookingTimeTF = cookingTimeTF.text
    }
    @IBAction func producerProductEditingChanged() {
        viewModel.textFromProducerTF = producerTF.text
    }
    
    @IBAction func closeButtonPressed() {
        dismiss(animated: true)
    }
    
    @IBAction func saveButtonPressed() {
        viewModel.validation() ?
            successfulValidation() :
            showAlert()
    }
    
    
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AddNewProductViewModel()
        setupGestures()
        
        
    }
    
    // MARK: - Private methods
    
    private func showAlert() {
        let alert = UIAlertController(title: "Упс...",
                                      message: viewModel.incorrectMessage,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) 
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    
    private func successfulValidation() {
        viewModel.codeLabelText = codeLabel.text
        viewModel.createProduct()
        viewModel.createProductInCoreData()
//        viewModel.createProductInFB()
        performSegue(withIdentifier: "unwindToProductInfo", sender: nil)
    }
    
    
    // MARK: - Override methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let productInfoVC = segue.destination as? ProductInfoViewController else {
            return }
        productInfoVC.viewModel = ProductInfoViewModel(product: viewModel.completedProduct)
        guard let recentProductVC = segue.destination.tabBarController?.viewControllers?.last
                as? RecentProductsViewController else { return }
        recentProductVC.recentProductCollectionView.viewModel = RecentProductCollectionViewViewModel()
        recentProductVC.recentProductCollectionView.viewModel.fetchProductFromCoreData {
            recentProductVC.recentProductCollectionView.reloadData()
        }
    }
}


//MARK: - PopOver Menu

extension AddNewProductViewController {
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tapGesture.numberOfTouchesRequired = 1
        categoryButton.addGestureRecognizer(tapGesture)
    }
    
    @objc private func tapped() {
        guard let popVC = storyboard?.instantiateViewController(identifier: "popVC") as? PopOverMenuTableViewController else { return }
        popVC.delegate = self
        popVC.viewModel = PopOverMenuTableViewModel()
        popVC.modalPresentationStyle = .popover
        
        let popOverVC = popVC.popoverPresentationController
        popOverVC?.delegate = self
        popOverVC?.sourceView = self.categoryButton
        popOverVC?.sourceRect = CGRect(x: self.categoryButton.bounds.midX / 2,
                                       y: self.categoryButton.bounds.midY,
                                       width: 0,
                                       height: 0)
        popVC.preferredContentSize = CGSize(width: popOverTableSize.width.rawValue,
                                            height: popOverTableSize.height.rawValue)
        self.present(popVC, animated: true)
    }
}


//MARK: - Extensions

extension AddNewProductViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}


extension AddNewProductViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}

extension AddNewProductViewController: AddNewProductViewControllerDelegate {
    func getSelectedItemFromPopOver(item: String) {
        categoryButton.setTitle(item, for: .normal)
        categoryButton.setTitleColor(.black, for: .normal)
        viewModel.categorySelected = true
        viewModel.selectedCategory = item
    }
}



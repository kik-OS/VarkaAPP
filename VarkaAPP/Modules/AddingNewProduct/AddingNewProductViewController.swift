//
//  AddingNewProductViewController.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 09.03.2021.
//

import UIKit

final class AddingNewProductViewController: UIViewController {
    
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
    
    var viewModel: AddingNewProductViewModelProtocol! {
        didSet {
            viewModel.getCategories()
        }
    }
    
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
        setupGestures()
        codeLabel.text = viewModel.codeLabelText
        addDoneButton(to: cookingTimeTF, weightTF, producerTF, titleProductTF )
//        cookingTimeTF.delegate = self
//        weightTF.delegate = self
        
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
        viewModel.initializeProduct()
        viewModel.createProductInFB()
        Notifications().showProductWasAddedNotification()
        performSegue(withIdentifier: "unwindToProductInfo", sender: nil)
    }
    
    // MARK: - Override methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let productInfoVC = segue.destination as? ProductInfoViewController else { return }
        productInfoVC.viewModel = ProductInfoViewModel(product: viewModel.completedProduct)
    }
}

//MARK: - PopOver Menu

extension AddingNewProductViewController {
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tapGesture.numberOfTouchesRequired = 1
        categoryButton.addGestureRecognizer(tapGesture)
    }
    
    @objc private func tapped() {
        guard let popVC = storyboard?.instantiateViewController(identifier: Inscriptions.popVCStoryBoardID) as? PopOverMenuTableViewController else { return }
        popVC.delegate = self
        popVC.viewModel = PopOverMenuTableViewModel(categories: viewModel.categories)
        popVC.modalPresentationStyle = .popover
        
        let popOverVC = popVC.popoverPresentationController
        popOverVC?.delegate = self
        popOverVC?.sourceView = self.categoryButton
        popOverVC?.sourceRect = CGRect(x: self.categoryButton.bounds.midX / 2,
                                       y: self.categoryButton.bounds.midY,
                                       width: 0,
                                       height: 0)
        popVC.preferredContentSize = CGSize(width: PopOverTableSize.width.rawValue,
                                            height: PopOverTableSize.height.rawValue)
        self.present(popVC, animated: true)
    }
}

//MARK: - Extensions

extension AddingNewProductViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension AddingNewProductViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}

extension AddingNewProductViewController: PopOverMenuTableViewControllerDelegate {
    func getSelectedItemFromPopOver(selectedCategory: String) {
        categoryButton.setTitle(selectedCategory, for: .normal)
        categoryButton.setTitleColor(.black, for: .normal)
        viewModel.categorySelected = true
        viewModel.selectedCategory = selectedCategory
    }
}

extension AddingNewProductViewController {
    //Функция для нажатия на кнопку done
     @objc private func didTapDone() {
        saveButtonPressed()
//            view.endEditing(true)
        }
    
    @objc private func didTapUp() {
        changedResponderForUpButton()
       }
    
    @objc private func didTapDown() {
        changedResponderForDownButton()
       }
    
    
        
       //Добавление кнопки
        private func addDoneButton(to textFields: UITextField...) {
            
            textFields.forEach { textField in
                let keyboardToolbar = UIToolbar()
                textField.inputAccessoryView = keyboardToolbar
                keyboardToolbar.sizeToFit()
                
                let doneButton = UIBarButtonItem(
                    title:"Готово",
                    style: .done,
                    target: self,
                    action: #selector(didTapDone)
                )
                
                let downButton = UIBarButtonItem(
                    title: "↓",
                    style: .done,
                    target: self,
                    action: #selector(didTapDown)
                )
                
                let upButton = UIBarButtonItem(
                    title:"↑",
                    style: .done,
                    target: self,
                    action: #selector(didTapUp)
                )
                
                let flexBarButton = UIBarButtonItem(
                    barButtonSystemItem: .flexibleSpace,
                    target: nil,
                    action: nil
                )
                
                keyboardToolbar.items = [downButton, upButton, flexBarButton, doneButton]
            }
        }
    
    
    func changedResponderForUpButton() {
//        let textFields = [titleProductTF, producerTF, cookingTimeTF, weightTF]

        if producerTF.isFirstResponder {
            titleProductTF.becomeFirstResponder()
        } else if cookingTimeTF.isFirstResponder {
            producerTF.becomeFirstResponder()
        } else if weightTF.isFirstResponder {
            cookingTimeTF.becomeFirstResponder()
        }
    }
    
    func changedResponderForDownButton() {
        if weightTF.isFirstResponder {
            view.endEditing(true)
        } else if cookingTimeTF.isFirstResponder {
            weightTF.becomeFirstResponder()
        } else if producerTF.isFirstResponder {
            cookingTimeTF.becomeFirstResponder()
        } else if titleProductTF.isFirstResponder {
            producerTF.becomeFirstResponder()
        }
    }
    
}
